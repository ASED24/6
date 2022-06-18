// LegacyESCDefines.h was generated by ProtoGen version 3.2.a

/*
 * This file is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Oliver Walters
 */

#pragma once

// Language target is C, C++ compilers: don't mangle us
#ifdef __cplusplus
extern "C" {
#endif

/*!
 * \file
 */

#include <stdbool.h>
#include "ESCVelocityProtocol.h"

/*!
 * Status bits associated with the legacy (gen-1) ESC
 */
typedef struct
{
    unsigned hwInhibit : 1;     //!< 1 = Hardware inhibit is active (ESC is disabled)
    unsigned swInhibit : 1;     //!< 1 = Software inhibit is active (ESC is disabled)
    unsigned afwEnabled : 1;    //!< 0 = Active Freewheeling is not enabled, 1 = Active Freewheeling is enabled
    unsigned direction : 1;     //!< 0 = Motor direction is FORWARDS, 1= Motor direction is REVERSE
    unsigned timeout : 1;       //!< Set if the ESC command timeout period has elapsed (and the ESC is in STANDBY mode)
    unsigned starting : 1;      //!< 1 = in starting mode (0 = stopped or running)
    unsigned commandSource : 1; //!< 0 = most recent command from CAN, 1 = most recent command from PWM
    unsigned running : 1;       //!< ESC is running
}ESC_LegacyStatusBits_t;

//! return the minimum encoded length for the ESC_LegacyStatusBits_t structure
#define getMinLengthOfESC_LegacyStatusBits_t() (1)

//! return the maximum encoded length for the ESC_LegacyStatusBits_t structure
#define getMaxLengthOfESC_LegacyStatusBits_t() (1)

//! Encode a ESC_LegacyStatusBits_t into a byte array
void encodeESC_LegacyStatusBits_t(uint8_t* data, int* bytecount, const ESC_LegacyStatusBits_t* user);

//! Decode a ESC_LegacyStatusBits_t from a byte array
int decodeESC_LegacyStatusBits_t(const uint8_t* data, int* bytecount, ESC_LegacyStatusBits_t* user);

/*!
 * Warning bits associated with the legacy (gen-1) ESC
 */
typedef struct
{
    unsigned noRPMSignal : 1;      //!< Set if RPM signal is not detected
    unsigned overspeed : 1;        //!< Set if the ESC motor speed exceeds the configured warning threshold
    unsigned overcurrent : 1;      //!< Set if the ESC motor current (positive or negative) exceeds the configured warning threshold
    unsigned escTemperature : 1;   //!< Set if the internal ESC temperature is above the warning threshold
    unsigned motorTemperature : 1; //!< Set if the motor temperature is above the warning threshold
    unsigned undervoltage : 1;     //!< Set if the input voltage is below the minimum threshold
    unsigned overvoltage : 1;      //!< Set if the input voltage is above the maximum threshold
    unsigned invalidPWMsignal : 1; //!< Set if hardware PWM input is enabled but invalid
}ESC_LegacyWarningBits_t;

//! return the minimum encoded length for the ESC_LegacyWarningBits_t structure
#define getMinLengthOfESC_LegacyWarningBits_t() (1)

//! return the maximum encoded length for the ESC_LegacyWarningBits_t structure
#define getMaxLengthOfESC_LegacyWarningBits_t() (1)

//! Encode a ESC_LegacyWarningBits_t into a byte array
void encodeESC_LegacyWarningBits_t(uint8_t* data, int* bytecount, const ESC_LegacyWarningBits_t* user);

//! Decode a ESC_LegacyWarningBits_t from a byte array
int decodeESC_LegacyWarningBits_t(const uint8_t* data, int* bytecount, ESC_LegacyWarningBits_t* user);

/*!
 * Error bits associated with the legacy (gen-1) ESC
 */
typedef struct
{
    unsigned linkError : 1;        //!< Set if communication link to the motor controller is lost
    unsigned foldback : 1;         //!< Set if the ESC has detected an overcurrent event and is actively folding back duty cycle
    unsigned settingsChecksum : 1; //!< Set if the settings checksum does not match the programmed values
    unsigned motorSettings : 1;    //!< Set if the motor settings are invalid
    unsigned reservedD : 1;        //!< Reserved for future use
    unsigned reservedE : 1;        //!< Reserved for future use
    unsigned reservedF : 1;        //!< Reserved for future use
    unsigned reservedG : 1;        //!< Reserved for future use
}ESC_LegacyErrorBits_t;

//! return the minimum encoded length for the ESC_LegacyErrorBits_t structure
#define getMinLengthOfESC_LegacyErrorBits_t() (1)

//! return the maximum encoded length for the ESC_LegacyErrorBits_t structure
#define getMaxLengthOfESC_LegacyErrorBits_t() (1)

//! Encode a ESC_LegacyErrorBits_t into a byte array
void encodeESC_LegacyErrorBits_t(uint8_t* data, int* bytecount, const ESC_LegacyErrorBits_t* user);

//! Decode a ESC_LegacyErrorBits_t from a byte array
int decodeESC_LegacyErrorBits_t(const uint8_t* data, int* bytecount, ESC_LegacyErrorBits_t* user);

#ifdef __cplusplus
}
#endif
