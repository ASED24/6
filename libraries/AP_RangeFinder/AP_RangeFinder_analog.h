#pragma once

#include "AP_RangeFinder.h"
#include "AP_RangeFinder_Backend.h"
#include "AP_RangeFinder_Params.h"

#ifndef AP_RANGEFINDER_ANALOG_ENABLED
#define AP_RANGEFINDER_ANALOG_ENABLED AP_RANGEFINDER_BACKEND_DEFAULT_ENABLED
#endif

#if AP_RANGEFINDER_ANALOG_ENABLED

class AP_RangeFinder_analog : public AP_RangeFinder_Backend
{
public:
    // constructor
    AP_RangeFinder_analog(RangeFinder::RangeFinder_State &_state, AP_RangeFinder_Params &_params);

    // static detection function
    static bool detect(AP_RangeFinder_Params &_params);

    // update state
    void update(void) override;

    uint16_t voltage_mv() const override { return _voltage_mv; }

protected:

    MAV_DISTANCE_SENSOR _get_mav_distance_sensor_type() const override {
        return MAV_DISTANCE_SENSOR_UNKNOWN;
    }

private:
    // update raw voltage
    void update_voltage(void);

    AP_HAL::AnalogSource *source;

    uint16_t _voltage_mv;            // voltage in millivolts
};

#endif
