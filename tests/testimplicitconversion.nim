import std/unittest
import durations
import ./funcs

test "implicit conversion":
  check compiles(getCountMilli(5.seconds))
  check getCountMilli(5.seconds) == 5000
  check getCountMicro(5.milliseconds) == 5000
  check getCountMicro(5.seconds) == 5_000_000

test "no implicit conversion to lower precision":
  check not compiles(getCountSeconds(5.milliseconds))
  check not compiles(getCountSeconds(5.microseconds))
