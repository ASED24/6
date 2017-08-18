#!/usr/bin/env python

# Fly ArduPlane in SITL
from __future__ import print_function
import math
import os
import shutil

import pexpect
from pymavlink import mavutil

from common import *
from pysim import util

# get location of scripts
testdir = os.path.dirname(os.path.realpath(__file__))
HOME = mavutil.location(-35.362938, 149.165085, 585, 354)
WIND = "0,180,0.2"  # speed,direction,variance


class AutotestPlane(Autotest):
    def __init__(self, binary, viewerip=None, use_map=False, valgrind=False, gdb=False, speedup=10, frame=None, params=None):
        super(AutotestPlane, self).__init__()
        self.binary = binary
        self.options = '--sitl=127.0.0.1:5501 --out=127.0.0.1:19550 --streamrate=10'
        self.viewerip = viewerip
        self.use_map = use_map
        self.valgrind = valgrind
        self.gdb = gdb
        self.frame = frame
        self.params = params

        self.home = "%f,%f,%u,%u" % (HOME.lat, HOME.lng, HOME.alt, HOME.heading)
        self.homeloc = None
        self.speedup = speedup
        self.speedup_default = 10

        self.sitl = None
        self.hasInit = False

    def init(self):
        if self.frame is None:
            self.frame = 'plane-elevrev'

        if self.viewerip:
            self.options += " --out=%s:14550" % self.viewerip
        if self.use_map:
            self.options += ' --map'

        self.sitl = util.start_SITL(self.binary, wipe=True, model=self.frame, home=self.home, speedup=self.speedup,
                                    defaults_file=os.path.join(testdir, 'default_params/plane-jsbsim.parm'),
                                    valgrind=self.valgrind, gdb=self.gdb)
        self.mavproxy = util.start_MAVProxy_SITL('ArduPlane', options=self.options)
        self.mavproxy.expect('Telemetry log: (\S+)')
        logfile = self.mavproxy.match.group(1)
        progress("LOGFILE %s" % logfile)

        buildlog = util.reltopdir("../buildlogs/ArduPlane-test.tlog")
        progress("buildlog=%s" % buildlog)
        if os.path.exists(buildlog):
            os.unlink(buildlog)
        try:
            os.link(logfile, buildlog)
        except Exception:
            pass

        self.mavproxy.expect('Received [0-9]+ parameters')

        util.expect_setup_callback(self.mavproxy, expect_callback)

        expect_list_clear()
        expect_list_extend([self.sitl, self.mavproxy])

        progress("Started simulator")

        # get a mavlink connection going
        try:
            self.mav = mavutil.mavlink_connection('127.0.0.1:19550', robust_parsing=True)
        except Exception as msg:
            progress("Failed to start mavlink connection on 127.0.0.1:19550" % msg)
            raise
        self.self.mav.message_hooks.append(message_hook)
        self.self.mav.idle_hooks.append(idle_hook)
        self.hasInit = True
        progress("Ready to start testing!")

    def close(self):
        if self.use_map:
            self.mavproxy.send("module unload map\n")
            self.mavproxy.expect("Unloaded module map")

        self.self.mav.close()
        util.pexpect_close(self.mavproxy)
        util.pexpect_close(self.sitl)

        valgrind_log = util.valgrind_log_filepath(binary=self.binary, model=self.frame)
        if os.path.exists(valgrind_log):
            os.chmod(valgrind_log, 0o644)
            shutil.copy(valgrind_log, util.reltopdir("../buildlogs/ArduPlane-valgrind.log"))

    def test_arm_motors_radio(self):
        super(AutotestPlane, self).test_arm_motors_radio()

    def test_disarm_motors_radio(self):
        super(AutotestPlane, self).test_disarm_motors_radio()

    def test_autodisarm_motors(self):
        super(AutotestPlane, self).test_autodisarm_motors()

    def test_rtl(self, home, distance_min=10, timeout=250):
        super(AutotestPlane, self).test_rtl(home, distance_min=10, timeout=250)

    def test_throttle_failsafe(self, home, distance_min=10, side=60, timeout=180):
        super(AutotestPlane, self).test_throttle_failsafe(home, distance_min=10, side=60, timeout=180)

    def test_mission(self, filename):
        super(AutotestPlane, self).test_mission(filename)

    def takeoff(self):
        """Takeoff get to 30m altitude."""

        self.wait_ready_to_arm()
        self.arm_vehicle()

        self.mavproxy.send('switch 4\n')
        self.wait_mode('FBWA')

        # some rudder to counteract the prop torque
        self.mavproxy.send('rc 4 1700\n')

        # some up elevator to keep the tail down
        self.mavproxy.send('rc 2 1200\n')

        # get it moving a bit first
        self.mavproxy.send('rc 3 1300\n')
        self.mav.recv_match(condition='VFR_HUD.groundspeed>6', blocking=True)

        # a bit faster again, straighten rudder
        self.mavproxy.send('rc 3 1600\n')
        self.mavproxy.send('rc 4 1500\n')
        self.mav.recv_match(condition='VFR_HUD.groundspeed>12', blocking=True)

        # hit the gas harder now, and give it some more elevator
        self.mavproxy.send('rc 2 1100\n')
        self.mavproxy.send('rc 3 2000\n')

        # gain a bit of altitude
        if not self.wait_altitude(homeloc.alt+150, homeloc.alt+180, timeout=30):
            return False

        # level off
        self.mavproxy.send('rc 2 1500\n')

        progress("TAKEOFF COMPLETE")
        return True

    def fly_left_circuit(self):
        """Fly a left circuit, 200m on a side."""
        self.mavproxy.send('switch 4\n')
        self.wait_mode('FBWA')
        self.mavproxy.send('rc 3 2000\n')
        if not self.wait_level_flight():
            return False

        progress("Flying left circuit")
        # do 4 turns
        for i in range(0, 4):
            # hard left
            progress("Starting turn %u" % i)
            self.mavproxy.send('rc 1 1000\n')
            if not self.wait_heading(270 - (90*i), accuracy=10):
                return False
            self.mavproxy.send('rc 1 1500\n')
            progress("Starting leg %u" % i)
            if not self.wait_distance(100, accuracy=20):
                return False
        progress("Circuit complete")
        return True

    def fly_RTL(self):
        """Fly to home."""
        progress("Flying home in RTL")
        self.mavproxy.send('switch 2\n')
        self.wait_mode('RTL')
        if not self.wait_location(homeloc, accuracy=120,
                             target_altitude=homeloc.alt+100, height_accuracy=20,
                             timeout=180):
            return False
        progress("RTL Complete")
        return True

    def fly_LOITER(self, num_circles=4):
        """Loiter where we are."""
        progress("Testing LOITER for %u turns" % num_circles)
        self.mavproxy.send('loiter\n')
        self.wait_mode('LOITER')

        m = self.mav.recv_match(type='VFR_HUD', blocking=True)
        initial_alt = m.alt
        progress("Initial altitude %u\n" % initial_alt)

        while num_circles > 0:
            if not self.wait_heading(0, accuracy=10, timeout=60):
                return False
            if not self.wait_heading(180, accuracy=10, timeout=60):
                return False
            num_circles -= 1
            progress("Loiter %u circles left" % num_circles)

        m = self.mav.recv_match(type='VFR_HUD', blocking=True)
        final_alt = m.alt
        progress("Final altitude %u initial %u\n" % (final_alt, initial_alt))

        self.mavproxy.send('mode FBWA\n')
        self.wait_mode('FBWA')

        if abs(final_alt - initial_alt) > 20:
            progress("Failed to maintain altitude")
            return False

        progress("Completed Loiter OK")
        return True

    def fly_CIRCLE(self, num_circles=1):
        """Circle where we are."""
        progress("Testing CIRCLE for %u turns" % num_circles)
        self.mavproxy.send('mode CIRCLE\n')
        self.wait_mode('CIRCLE')

        m = self.mav.recv_match(type='VFR_HUD', blocking=True)
        initial_alt = m.alt
        progress("Initial altitude %u\n" % initial_alt)

        while num_circles > 0:
            if not self.wait_heading(0, accuracy=10, timeout=60):
                return False
            if not self.wait_heading(180, accuracy=10, timeout=60):
                return False
            num_circles -= 1
            progress("CIRCLE %u circles left" % num_circles)

        m = self.mav.recv_match(type='VFR_HUD', blocking=True)
        final_alt = m.alt
        progress("Final altitude %u initial %u\n" % (final_alt, initial_alt))

        self.mavproxy.send('mode FBWA\n')
        self.wait_mode('FBWA')

        if abs(final_alt - initial_alt) > 20:
            progress("Failed to maintain altitude")
            return False

        progress("Completed CIRCLE OK")
        return True

    def wait_level_flight(self, accuracy=5, timeout=30):
        """Wait for level flight."""
        tstart = self.get_sim_time()
        progress("Waiting for level flight")
        self.mavproxy.send('rc 1 1500\n')
        self.mavproxy.send('rc 2 1500\n')
        self.mavproxy.send('rc 4 1500\n')
        while self.get_sim_time() < tstart + timeout:
            m = self.mav.recv_match(type='ATTITUDE', blocking=True)
            roll = math.degrees(m.roll)
            pitch = math.degrees(m.pitch)
            progress("Roll=%.1f Pitch=%.1f" % (roll, pitch))
            if math.fabs(roll) <= accuracy and math.fabs(pitch) <= accuracy:
                progress("Attained level flight")
                return True
        progress("Failed to attain level flight")
        return False

    def change_altitude(self, altitude, accuracy=30):
        """Get to a given altitude."""
        self.mavproxy.send('mode FBWA\n')
        self.wait_mode('FBWA')
        alt_error = self.mav.messages['VFR_HUD'].alt - altitude
        if alt_error > 0:
            self.mavproxy.send('rc 2 2000\n')
        else:
            self.mavproxy.send('rc 2 1000\n')
        if not self.wait_altitude(altitude-accuracy/2, altitude+accuracy/2):
            return False
        self.mavproxy.send('rc 2 1500\n')
        progress("Reached target altitude at %u" % self.mav.messages['VFR_HUD'].alt)
        return self.wait_level_flight()

    def axial_left_roll(self, count=1):
        """Fly a left axial roll."""
        # full throttle!
        self.mavproxy.send('rc 3 2000\n')
        if not self.change_altitude(homeloc.alt+300):
            return False

        # fly the roll in manual
        self.mavproxy.send('switch 6\n')
        self.wait_mode('MANUAL')

        while count > 0:
            progress("Starting roll")
            self.mavproxy.send('rc 1 1000\n')
            if not self.wait_roll(-150, accuracy=90):
                self.mavproxy.send('rc 1 1500\n')
                return False
            if not self.wait_roll(150, accuracy=90):
                self.mavproxy.send('rc 1 1500\n')
                return False
            if not self.wait_roll(0, accuracy=90):
                self.mavproxy.send('rc 1 1500\n')
                return False
            count -= 1

        # back to FBWA
        self.mavproxy.send('rc 1 1500\n')
        self.mavproxy.send('switch 4\n')
        self.wait_mode('FBWA')
        self.mavproxy.send('rc 3 1700\n')
        return self.wait_level_flight()

    def inside_loop(self, count=1):
        """Fly a inside loop."""
        # full throttle!
        self.mavproxy.send('rc 3 2000\n')
        if not self.change_altitude(homeloc.alt+300):
            return False

        # fly the loop in manual
        self.mavproxy.send('switch 6\n')
        self.wait_mode('MANUAL')

        while count > 0:
            progress("Starting loop")
            self.mavproxy.send('rc 2 1000\n')
            if not self.wait_pitch(-60, accuracy=20):
                return False
            if not self.wait_pitch(0, accuracy=20):
                return False
            count -= 1

        # back to FBWA
        self.mavproxy.send('rc 2 1500\n')
        self.mavproxy.send('switch 4\n')
        self.wait_mode('FBWA')
        self.mavproxy.send('rc 3 1700\n')
        return self.wait_level_flight()

    def test_stabilize(self, count=1):
        """Fly stabilize mode."""
        # full throttle!
        self.mavproxy.send('rc 3 2000\n')
        self.mavproxy.send('rc 2 1300\n')
        if not self.change_altitude(homeloc.alt+300):
            return False
        self.mavproxy.send('rc 2 1500\n')

        self.mavproxy.send("mode STABILIZE\n")
        self.wait_mode('STABILIZE')

        count = 1
        while count > 0:
            progress("Starting roll")
            self.mavproxy.send('rc 1 2000\n')
            if not self.wait_roll(-150, accuracy=90):
                return False
            if not self.wait_roll(150, accuracy=90):
                return False
            if not self.wait_roll(0, accuracy=90):
                return False
            count -= 1

        self.mavproxy.send('rc 1 1500\n')
        if not self.wait_roll(0, accuracy=5):
            return False

        # back to FBWA
        self.mavproxy.send('mode FBWA\n')
        self.wait_mode('FBWA')
        self.mavproxy.send('rc 3 1700\n')
        return self.wait_level_flight()

    def test_acro(self, count=1):
        """Fly ACRO mode."""
        # full throttle!
        self.mavproxy.send('rc 3 2000\n')
        self.mavproxy.send('rc 2 1300\n')
        if not self.change_altitude(homeloc.alt+300):
            return False
        self.mavproxy.send('rc 2 1500\n')

        self.mavproxy.send("mode ACRO\n")
        self.wait_mode('ACRO')

        count = 1
        while count > 0:
            progress("Starting roll")
            self.mavproxy.send('rc 1 1000\n')
            if not self.wait_roll(-150, accuracy=90):
                return False
            if not self.wait_roll(150, accuracy=90):
                return False
            if not self.wait_roll(0, accuracy=90):
                return False
            count -= 1
        self.mavproxy.send('rc 1 1500\n')

        # back to FBWA
        self.mavproxy.send('mode FBWA\n')
        self.wait_mode('FBWA')

        self.wait_level_flight()

        self.mavproxy.send("mode ACRO\n")
        self.wait_mode('ACRO')

        count = 2
        while count > 0:
            progress("Starting loop")
            self.mavproxy.send('rc 2 1000\n')
            if not self.wait_pitch(-60, accuracy=20):
                return False
            if not self.wait_pitch(0, accuracy=20):
                return False
            count -= 1

        self.mavproxy.send('rc 2 1500\n')

        # back to FBWA
        self.mavproxy.send('mode FBWA\n')
        self.wait_mode('FBWA')
        self.mavproxy.send('rc 3 1700\n')
        return self.wait_level_flight()

    def test_FBWB(self, count=1, mode='FBWB'):
        """Fly FBWB or CRUISE mode."""
        self.mavproxy.send("mode %s\n" % mode)
        self.wait_mode(mode)
        self.mavproxy.send('rc 3 1700\n')
        self.mavproxy.send('rc 2 1500\n')

        # lock in the altitude by asking for an altitude change then releasing
        self.mavproxy.send('rc 2 1000\n')
        self.wait_distance(50, accuracy=20)
        self.mavproxy.send('rc 2 1500\n')
        self.wait_distance(50, accuracy=20)

        m = self.mav.recv_match(type='VFR_HUD', blocking=True)
        initial_alt = m.alt
        progress("Initial altitude %u\n" % initial_alt)

        progress("Flying right circuit")
        # do 4 turns
        for i in range(0, 4):
            # hard left
            progress("Starting turn %u" % i)
            self.mavproxy.send('rc 1 1800\n')
            if not self.wait_heading(0 + (90*i), accuracy=20, timeout=60):
                self.mavproxy.send('rc 1 1500\n')
                return False
            self.mavproxy.send('rc 1 1500\n')
            progress("Starting leg %u" % i)
            if not self.wait_distance(100, accuracy=20):
                return False
        progress("Circuit complete")

        progress("Flying rudder left circuit")
        # do 4 turns
        for i in range(0, 4):
            # hard left
            progress("Starting turn %u" % i)
            self.mavproxy.send('rc 4 1900\n')
            if not self.wait_heading(360 - (90*i), accuracy=20, timeout=60):
                self.mavproxy.send('rc 4 1500\n')
                return False
            self.mavproxy.send('rc 4 1500\n')
            progress("Starting leg %u" % i)
            if not self.wait_distance(100, accuracy=20):
                return False
        progress("Circuit complete")

        m = self.mav.recv_match(type='VFR_HUD', blocking=True)
        final_alt = m.alt
        progress("Final altitude %u initial %u\n" % (final_alt, initial_alt))

        # back to FBWA
        self.mavproxy.send('mode FBWA\n')
        self.wait_mode('FBWA')

        if abs(final_alt - initial_alt) > 20:
            progress("Failed to maintain altitude")
            return False

        return self.wait_level_flight()

    def fly_mission(self, filename, height_accuracy=-1, target_altitude=None):
        """Fly a mission from a file."""
        global homeloc
        progress("Flying mission %s" % filename)
        self.mavproxy.send('wp load %s\n' % filename)
        self.mavproxy.expect('Flight plan received')
        self.mavproxy.send('wp list\n')
        self.mavproxy.expect('Requesting [0-9]+ waypoints')
        self.mavproxy.send('switch 1\n')  # auto mode
        self.wait_mode('AUTO')
        if not self.wait_waypoint(1, 7, max_dist=60):
            return False
        if not self.wait_groundspeed(0, 0.5, timeout=60):
            return False
        self.mavproxy.expect("Auto disarmed")
        progress("Mission OK")
        return True

    def fly_ArduPlane(self):
        """Fly ArduPlane in SITL.

        you can pass viewerip as an IP address to optionally send fg and
        mavproxy packets too for local viewing of the flight in real time
        """
        if not self.hasInit:
            self.init()

        failed = False
        fail_list = []
        e = 'None'
        try:
            progress("Waiting for a heartbeat with mavlink protocol %s" % self.mav.WIRE_PROTOCOL_VERSION)
            self.mav.wait_heartbeat()
            progress("Setting up RC parameters")
            self.set_rc_default()
            self.mavproxy.send('rc 3 1000\n')
            self.mavproxy.send('rc 8 1800\n')
            progress("Waiting for GPS fix")
            self.mav.recv_match(condition='VFR_HUD.alt>10', blocking=True)
            self.mav.wait_gps_fix()
            while self.mav.location().alt < 10:
                self.mav.wait_gps_fix()
            self.homeloc = self.mav.location()
            progress("Home location: %s" % self.homeloc)
            if not self.takeoff():
                progress("Failed takeoff")
                failed = True
                fail_list.append("takeoff")
            if not self.fly_left_circuit():
                progress("Failed left circuit")
                failed = True
                fail_list.append("left_circuit")
            if not self.axial_left_roll(1):
                progress("Failed left roll")
                failed = True
                fail_list.append("left_roll")
            if not self.inside_loop():
                progress("Failed inside loop")
                failed = True
                fail_list.append("inside_loop")
            if not self.test_stabilize():
                progress("Failed stabilize test")
                failed = True
                fail_list.append("stabilize")
            if not self.test_acro():
                progress("Failed ACRO test")
                failed = True
                fail_list.append("acro")
            if not self.test_FBWB():
                progress("Failed FBWB test")
                failed = True
                fail_list.append("fbwb")
            if not self.test_FBWB(mode='CRUISE'):
                progress("Failed CRUISE test")
                failed = True
                fail_list.append("cruise")
            if not self.fly_RTL():
                progress("Failed RTL")
                failed = True
                fail_list.append("RTL")
            if not self.fly_LOITER():
                progress("Failed LOITER")
                failed = True
                fail_list.append("LOITER")
            if not self.fly_CIRCLE():
                progress("Failed CIRCLE")
                failed = True
                fail_list.append("LOITER")
            if not self.fly_mission(os.path.join(testdir, "ap1.txt"), height_accuracy=10,
                                    target_altitude=homeloc.alt+100):
                progress("Failed mission")
                failed = True
                fail_list.append("mission")
            if not self.log_download(util.reltopdir("../buildlogs/ArduPlane-log.bin")):
                progress("Failed log download")
                failed = True
                fail_list.append("log_download")
        except pexpect.TIMEOUT as e:
            progress("Failed with timeout")
            failed = True
            fail_list.append("timeout")

        self.close()

        if failed:
            progress("FAILED: %s" % e, fail_list)
            return False
        return True
