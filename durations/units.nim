import ./core
import ./unitdef
import std/math

unit Nano, Nanoseconds, 1 // 10 ^ 9
unit Micro, Microseconds, 1 // 10 ^ 6
unit Milli, Milliseconds, 1 // 10 ^ 3
unit Unit, Seconds, 1 // 1
unit MinuteRatio, Minutes, 60 // 1
unit HourRatio, Hours, MinuteRatio * 60
unit DayRatio, Days, HourRatio * 24
