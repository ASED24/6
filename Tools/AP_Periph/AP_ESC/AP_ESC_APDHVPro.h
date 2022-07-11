
#pragma once

#include "AP_ESC.h"
#include "AP_ESC_Backend.h"


#define SINGLE_LOOP_MAX_BYTES 500
#define BUFFER_LOOP_SIZE 44
#define ESC_PACKET_SIZE 22



typedef struct {
    uint16_t voltage;
    uint16_t temperature;
    uint16_t bus_current;
    uint16_t reserved1;
    uint32_t rpm;
    uint16_t input_duty;
    uint16_t motor_duty;
    uint8_t  status;
    uint8_t  reserved2;
    uint16_t checksum;

}APD_struct;


class AP_ESC_APDHVPro {
public:
    // constructor
    AP_ESC_APDHVPro();

    void init(AP_HAL::UARTDriver *uart);

    // update the structure
    bool update();

    APD_struct decoded;

private:
    // AP_ESC *_frontend;

    AP_HAL::UARTDriver *port;

    uint32_t last_read_ms;

    uint8_t max_buffer[SINGLE_LOOP_MAX_BYTES];
    uint8_t raw_buffer[ESC_PACKET_SIZE];

    bool read_ESC_telemetry_data(uint32_t);
    bool parse_ESC_telemetry_data();
    int check_flectcher16();
};
