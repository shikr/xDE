local lgi = require('lgi')
local gobject = require('gears.object')
local NM = lgi.require('NM', '1.0')

local instance = nil

local network = {}

local function get_device(client, device_type)
  for _, device in ipairs(client:get_devices()) do
    if device:get_device_type() == device_type then
      return device
    end
  end

  return nil
end

local function get_connection_type(client)
  local connection = client:get_primary_connection() or client:get_activating_connection()

  if connection ~= nil then
    local conn_type = connection:get_connection_type()

    if conn_type == '802-11-wireless' then
      return 'wifi'
    elseif conn_type == '802-3-ethernet' then
      return 'wired'
    end
  end
end

--- @return 'connected' | 'connecting' | 'failed' | 'disconnected'
local function device_state(state)
  local defined_states = {
    ['ACTIVATED'] = 'connected',
    ['ACTIVATING'] = 'connecting',
    ['DEACTIVATING'] = 'connecting',
    ['PREPARE'] = 'connecting',
    ['IP_CONFIG'] = 'connecting',
    ['IP_CHECK'] = 'connecting',
    ['SECONDARIES'] = 'connecting',
    ['FAILED'] = 'failed',
    ['NEED_AUTH'] = 'failed',
  }

  return defined_states[state] or 'disconnected'
end

function network:get_access_point()
  if self.wifi ~= nil then
    self.access_point = self.wifi:get_active_access_point()

    if self.access_point ~= nil then
      local on_strength_change = function ()
        self.strength = self.access_point:get_strength()
      end

      self.access_point.on_notify.strength = on_strength_change
      self.strength = self.access_point:get_strength()
    end
  end
end

function network:get_primary_device()
  if self.primary_type ~= nil then
    return self[self.primary_type]
  end

  return nil
end

function network:check_state(state)
  if state == nil then
    local device = self:get_primary_device()

    if device ~= nil then
      state = device:get_state()
    end
  end

  local device_type = self.primary_type
  local dev_state = device_state(state)

  if device_type == 'wifi' then
    if dev_state == 'connected' then
      local states = {
        ['high'] = 75,
        ['medium'] = 50,
        ['low'] = 25,
        ['none'] = 0,
      }

      for name, value in pairs(states) do
        if self.strength >= value then
          return 'wifi-' .. name
        end
      end
    end

    if dev_state == 'connecting' then
      return 'connecting'
    end

    if dev_state == 'failed' or self.wifi_enabled then
      return 'wifi-failed'
    end

    if not self.wifi_enabled then
      return 'wifi-disabled'
    end
  elseif device_type == 'wired' then
    if dev_state == 'connecting' then
      return 'connecting'
    end

    -- TEST: test without internet connection
    if self.client:get_connectivity() ~= 'FULL' then
      return 'failed'
    end

    if dev_state == 'connected' then
      return 'connected'
    end
  end

  return 'failed'
end

local function new()
  local manager = gobject {
    class = network,
    enable_properties = true,
    enable_auto_signals = true,
  }
  manager.client = NM.Client.new()
  manager.wifi = get_device(manager.client, 'WIFI')
  manager.wired = get_device(manager.client, 'ETHERNET')
  manager.primary_type = get_connection_type(manager.client)
  manager.wifi_enabled = manager.client:wireless_get_enabled()
  manager.strength = 0
  manager.state = manager:check_state()

  manager:get_access_point()
  if manager.wifi ~= nil then
    local on_ap_change = function ()
      manager:get_access_point()
    end

    local on_state_changed = function (_, state)
      if manager.primary_type == 'wifi' then
        manager.state = manager:check_state(state)
      end
    end

    manager.wifi.on_notify['active-access-point'] = on_ap_change
    manager.wifi.on_access_point_added = on_ap_change
    manager.wifi.on_access_point_removed = on_ap_change
    manager.wifi.on_state_changed = on_state_changed
  end

  if manager.wired ~= nil then
    local on_state_changed = function (_, state)
      if manager.primary_type == 'wired' then
        manager.state = manager:check_state(state)
      end
    end

    manager.wired.on_state_changed = on_state_changed
  end

  local check_state = function ()
    manager.state = manager:check_state()
  end

  manager:connect_signal('property::primary_type', check_state)
  manager:connect_signal('property::strength', check_state)

  local on_connection_change = function ()
    local new_type = get_connection_type(client)
    if new_type ~= manager.primary_type then
      manager.primary_type = new_type
    end
  end

  local on_wireless_change = function ()
    manager.wifi_enabled = manager.client:wireless_get_enabled()
  end

  manager.client.on_notify.connectivity = check_state
  manager.client.on_notify['primary-connection'] = on_connection_change
  manager.client.on_notify['activating-connection'] = on_connection_change
  manager.client.on_notify['wireless-enabled'] = on_wireless_change

  return manager
end

if instance == nil then
  instance = new()
end

return instance
