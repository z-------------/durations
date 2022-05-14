import durations
import std/unittest

template checkTypeAndCount(expr, expected: untyped) =
  let d = expr
  check d is typeof(expected)
  check d.count == expected.count

test "arithmetic":
  checkTypeAndCount(6.seconds + 9.seconds, 15.seconds)
  checkTypeAndCount(5.seconds + 100.milliseconds, 5100.milliseconds)

  checkTypeAndCount(6.seconds - 9.seconds, (-3).seconds)
  checkTypeAndCount(5.seconds - 100.milliseconds, 4900.milliseconds)

test "conversions":
  check 5.seconds.to(Milliseconds).count == 5000
  check 3500.milliseconds.to(Seconds).count == 3
  check 3500.milliseconds.to(Milliseconds).count == 3500

test "dollars":
  check $5.seconds == "5 seconds"
  check $5.milliseconds == "5 milliseconds"
  check $initDuration[Milli](5) == "5 milliseconds"
  check $initDuration[initRatio(22, 7)](5) == "Duration[22/7](5)"
