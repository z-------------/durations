import ./core
import ./unitdef
import std/math

unit Nano, Nanoseconds, initRatio(1, 10 ^ 9)
unit Micro, Microseconds, initRatio(1, 10 ^ 6)
unit Milli, Milliseconds, initRatio(1, 10 ^ 3)
unit Unit, Seconds, initRatio(1, 1)
unit MinuteRatio, Minutes, initRatio(60, 1)
unit HourRatio, Hours, MinuteRatio * 60
unit DayRatio, Days, HourRatio * 24

generateImplicitConverters()
