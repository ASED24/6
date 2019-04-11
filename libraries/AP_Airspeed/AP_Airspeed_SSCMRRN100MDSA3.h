/*
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#pragma once

/*
  backend driver for SPI SSCMRRN100MDSA3
 */

#include <AP_HAL/AP_HAL.h>
#include <AP_Param/AP_Param.h>
#include <AP_HAL/utility/OwnPtr.h>
#include <AP_HAL/I2CDevice.h>
#include <utility>

#include "AP_Airspeed_Backend.h"
#include <AP_HAL/SPIDevice.h>

class AP_Airspeed_SSCMRRN100MDSA3 : public AP_Airspeed_Backend
{
public:
    AP_Airspeed_SSCMRRN100MDSA3(AP_Airspeed &frontend, uint8_t _instance);
    ~AP_Airspeed_SSCMRRN100MDSA3(void) {}

    // probe and initialise the sensor
    bool init() override;

    // return the current differential_pressure in Pascal
    bool get_differential_pressure(float &pressure) override;

    // return the current temperature in degrees C, if available
    bool get_temperature(float &temperature) override;

private:
    void _measure();
    void _collect();
    void _timer();
    void _voltage_correction(float &diff_press_pa, float &temperature);
    float _get_pressure(int16_t dp_raw) const;
    float _get_temperature(int16_t dT_raw) const;

    float _temp_sum;
    float _press_sum;
    uint32_t _temp_count;
    uint32_t _press_count;
    float _temperature;
    float _pressure;
    uint32_t _last_sample_time_ms;
    uint32_t _measurement_started_ms;
    AP_HAL::OwnPtr<AP_HAL::SPIDevice> _dev;
};
