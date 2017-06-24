//
// Simple test for the AP_Scheduler interface
//

#include <AP_HAL/AP_HAL.h>
#include <AP_InertialSensor/AP_InertialSensor.h>

#define SCHEDULER_DEFAULT_LOOP_RATE  50
#include <AP_Scheduler/AP_Scheduler.h>

#include <AP_BoardConfig/AP_BoardConfig.h>

const AP_HAL::HAL& hal = AP_HAL::get_HAL();

class SchedTest {
public:
    void setup();
    void loop();

private:

    AP_InertialSensor ins;
    AP_Scheduler<SchedTest> scheduler = AP_Scheduler<SchedTest>(this, 50);
    static const AP_Task<SchedTest> scheduler_tasks[];

    uint32_t ins_counter;

    void ins_update(void);
    void one_hz_print(void);
    void five_second_call(void);
};

static SchedTest schedtest;

/*
  scheduler table - all regular tasks are listed here, along with how
  often they should be called (in 20ms units) and the maximum time
  they are expected to take (in microseconds)
 */
const AP_Task<SchedTest> SchedTest::scheduler_tasks[] = {
    AP_Task<SchedTest>::create(&SchedTest::ins_update,             50,   1000, "ins_update"),
    AP_Task<SchedTest>::create(&SchedTest::one_hz_print,            1,   1000, "one_hz_print"),
    AP_Task<SchedTest>::create(&SchedTest::five_second_call,      0.2,   1800, "five_second_call"),
};

void SchedTest::setup(void)
{

    AP_BoardConfig{}.init();

    ins.init(scheduler.get_loop_rate_hz());

    // initialise the scheduler
    scheduler.init(&scheduler_tasks[0], ARRAY_SIZE(scheduler_tasks));
}

void SchedTest::loop(void)
{
    // wait for an INS sample
    ins.wait_for_sample();

    // tell the scheduler one tick has passed
    scheduler.tick();

    // run all tasks that fit in 20ms
    scheduler.run(20000);
}

/*
  update inertial sensor, reading data 
 */
void SchedTest::ins_update(void)
{
    ins_counter++;
    ins.update();
}

/*
  print something once a second
 */
void SchedTest::one_hz_print(void)
{
    hal.console->printf("one_hz: t=%lu\n", (unsigned long)AP_HAL::millis());
}

/*
  print something every 5 seconds
 */
void SchedTest::five_second_call(void)
{
    hal.console->printf("five_seconds: t=%lu ins_counter=%u\n", (unsigned long)AP_HAL::millis(), ins_counter);
}

/*
  compatibility with old pde style build
 */
void setup(void);
void loop(void);

void setup(void)
{
    schedtest.setup();
}
void loop(void)
{
    schedtest.loop();
}
AP_HAL_MAIN();
