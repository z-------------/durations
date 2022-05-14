import durations
import std/unittest

template checkTypeAndCount(expr: untyped; expectedType: typedesc; expectedCount: Count) =
  let d = expr
  check d is expectedType
  check d.count == expectedCount

test "arithmetic":
  checkTypeAndCount(6.seconds + 9.seconds, Seconds, 15)
  checkTypeAndCount(5.seconds + 100.milliseconds, Milliseconds, 5100)

  checkTypeAndCount(6.seconds - 9.seconds, Seconds, -3)
  checkTypeAndCount(5.seconds - 100.milliseconds, Milliseconds, 4900)

test "conversions":
  check 5.seconds.to(Milliseconds).count == 5000
  check 3500.milliseconds.to(Seconds).count == 3
  check 3500.milliseconds.to(Milliseconds).count == 3500

test "dollars":
  check $5.seconds == "Seconds(5)"
  check $5.milliseconds == "Milliseconds(5)"
  check $initDuration[Milli](5) == "Milliseconds(5)"
  check $initDuration[initRatio(22, 7)](5) == "Duration[22/7](5)"
