#!/bin/sh

# Copyright (C) 2011 by Murilo Pereira <murilo@murilopereira.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Tailored for a Thinkpad X1.

acpid_logger() {
  logger "acpid: $1"
}

case "$1" in
  button/power)
    case "$2" in
      PWRF)
        acpid_logger "shutting down"
        shutdown -h now
        ;;
      *)
        acpid_logger "undefined button/power action: $*"
        ;;
    esac
    ;;
  button/lid)
    if ( grep -q open /proc/acpi/button/lid/LID/state ); then
      acpid_logger "lid opened"
    elif ( grep -q closed /proc/acpi/button/lid/LID/state ); then
      acpid_logger "lid closed"
      acpid_logger "entering sleep mode"
      pm-suspend
    else
      acpid_logger "undefined button/lid action: $*"
    fi
    ;;
  ibm/hotkey)
    case "$4" in
      00001001)
        acpid_logger "Fn+F1 pressed"
        ;;
      00001002)
        acpid_logger "locking computer"
        ;;
      00001003)
        acpid_logger "Fn+F3 pressed"
        ;;
      00001004)
        acpid_logger "entering sleep mode"
        pm-suspend
        ;;
      00001005)
        acpid_logger "toggling wireless connections"
        ;;
      00001006)
        acpid_logger "Fn+F6 pressed"
        ;;
      00001007)
        acpid_logger "Fn+F7 pressed"
        ;;
      00001010)
        # acpid_logger "increasing brightness"
        ;;
      00001011)
        # acpid_logger "decreasing brightness"
        ;;
      00001018)
        acpid_logger "ThinkVantage button pressed"
        ;;
      0000101b)
        acpid_logger "microphone mute toggle pressed"
        ;;
      0000101c)
        acpid_logger "backlit keyboard illumination key pressed"
        ;;
      00006030)
        acpid_logger "system thermal table changed"
        ;;
      00006040)
        acpid_logger "AC adapter related event"
        ;;
      *)
        acpid_logger "undefined ibm/hotkey action: $*"
        ;;
    esac
    ;;
  video)
    case "$3" in
      00000086)
        acpid_logger "increasing brightness"
        ;;
      00000087)
        acpid_logger "decreasing brightness"
        ;;
    esac
    ;;
  ac_adapter)
    case "$2" in
      AC)
        case "$4" in
          00000000)
            acpid_logger "AC adapter unplugged"
            ;;
          00000001)
            acpid_logger "AC adapter plugged"
            ;;
        esac
        ;;
      *)
        acpid_logger "undefined ac_adapter action: $*"
        ;;
    esac
    ;;
  battery)
    case "$2" in
      BAT0)
        case "$4" in
          00000000)
            acpid_logger "battery offline"
            ;;
          00000001)
            acpid_logger "battery online"
            ;;
          *)
            acpid_logger "undefined battery/BAT0 action: $*"
            ;;
        esac
        ;;
      *)
        acpid_logger "undefined battery action: $*"
        ;;
    esac
    ;;
  thermal_zone)
    case "$4" in
      00000000)
        acpid_logger "thermal zone event"
        ;;
      *)
        acpid_logger "undefined thermal_zone action: $*"
        ;;
    esac
    ;;
  *)
    acpid_logger "undefined action: $*"
    ;;
esac
