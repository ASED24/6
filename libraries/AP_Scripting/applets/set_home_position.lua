-- Script to set new home position with the RC
-- Sets the arming, preset or dynamic home position after 2 seconds that the switch is in the chosen position
-- Author: Marco Robustini, Alessandro Apostoli

local MAV_SEVERITY = {EMERGENCY=0, ALERT=1, CRITICAL=2, ERROR=3, WARNING=4, NOTICE=5, INFO=6, DEBUG=7}

-- setup param block, reserving 2 params beginning with HSW_
local PARAM_TABLE_KEY = 74
local PARAM_TABLE_PREFIX = 'HSW_'
assert(param:add_table(PARAM_TABLE_KEY, "HSW_", 4), 'could not add param table')

-- add a parameter and bind it to a variable
function bind_add_param(name, idx, default_value)
    assert(param:add_param(PARAM_TABLE_KEY, idx, name, default_value), string.format('could not add param %s', name))
    return Parameter(PARAM_TABLE_PREFIX .. name)
end

--[[
  // @Param: HSW_ENABLE
  // @DisplayName: Home switch enable
  // @Description: Home switch enable
--]]
HSW_ENABLE = bind_add_param('ENABLE', 1, 0)

--[[
  // @Param: HSW_PRESET_LAT
  // @DisplayName: Preset Home location latitude
  // @Description: Preset Home location latitude
--]]
HSW_PRESET_LAT = bind_add_param('PRESET_LAT', 2, 0) -- example value 44.123456

--[[
  // @Param: HSW_PRESET_LNG
  // @DisplayName: Preset Home location longitude
  // @Description: Preset Home location longitude
--]]
HSW_PRESET_LNG = bind_add_param('PRESET_LNG', 3, 0) -- example value 11.123456

--[[
  // @Param: HSW_PRESET_ALT
  // @DisplayName: Preset Home location altitude
  // @Description: Preset Home location altitude
  // @Units cm
--]]
HSW_PRESET_ALT = bind_add_param('PRESET_ALT', 4, 0) -- example value 1000 = 10m

local rc_option = 300
local sw_channel = rc:find_channel_for_option(rc_option)
local sw_last_pos = -1
local home_location
local script_enabled = false
local last_arming_status = false

gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: home switch script started"))

function update()
  if last_arming_status ~= arming:is_armed() then
    if arming:is_armed() then
      home_location = ahrs:get_home()
      if home_location then
        gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: vehicle armed, home set to current location"))
      end
    end
    last_arming_status = arming:is_armed()
  end

  if script_enabled ~= (HSW_ENABLE:get() > 0) then
    if HSW_ENABLE:get() > 0 then
      gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: home switch script ENABLED"))
    else
      gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: home switch script DISABLED"))
    end
    script_enabled = HSW_ENABLE:get() > 0
  end

  if not arming:is_armed() or HSW_ENABLE:get() == 0 then
    return update, 2000
  end

  -- Define and initialize the location object with desired coordinates
  local my_home_location = Location()

  my_home_location:lat(HSW_PRESET_LAT:get()*10000000)
  my_home_location:lng(HSW_PRESET_LNG:get()*10000000)
  my_home_location:alt(HSW_PRESET_ALT:get())

  local sw_pos = sw_channel:get_aux_switch_pos() -- expected 0,1,2
  if sw_pos ~= sw_last_pos then
    if sw_pos == 1 then
      -- MID set HOME to preset my_home_location
      if my_home_location:lat() ~= 0 and my_home_location:lng() ~= 0 then
        ahrs:set_home(my_home_location)
        gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: home set to preset position: Lat:%.7f Long:%.7f Alt:%.1f", my_home_location:lat()/10000000, my_home_location:lng()/10000000, my_home_location:alt()/100))
		gcs:send_text(MAV_SEVERITY.ALERT, string.format("Preset home activated"))
        else
          gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: preset home position missing, unable to set home to preset location"))
      end
    elseif sw_pos == 2 then
      -- HIGH set HOME to current position keeping altitude of previous home
      local location = ahrs:get_location()
      if location then
        current_home = ahrs:get_home()
        if current_home then
          location:alt(current_home:alt()) -- new home has same altitude as previous home
          ahrs:set_home(location)
          gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: home set to current position: Lat:%.7f Long:%.7f Alt:%.1f", location:lat()/10000000, location:lng()/10000000, location:alt()/100))
		  gcs:send_text(MAV_SEVERITY.ALERT, string.format("Dynamic home activated"))
        else
          gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: home position not set, unable to set home to current position"))
        end
      else
        gcs:send_text(MAV_SEVERITY.INFO, "HSW: waiting for GPS lock")
      end
    else
      -- LOW set HOME to arming location
      if home_location then
        ahrs:set_home(home_location)
        gcs:send_text(MAV_SEVERITY.INFO, string.format("HSW: home set to arming position: Lat:%.7f Long:%.7f Alt:%.1f", home_location:lat()/10000000, home_location:lng()/10000000, home_location:alt()/100))
		gcs:send_text(MAV_SEVERITY.ALERT, string.format("Arming home restored"))
    end
  end
    sw_last_pos = sw_pos -- debounce
  end
  return update, 2000
end

return update()
