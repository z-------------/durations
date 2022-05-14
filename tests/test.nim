import durations
import std/unittest

template checkTypeAndCount(expr: untyped; expectedType: typedesc; expectedCount: Count) =
  let d = expr
  check d is expectedType
  check d.count == expectedCount

test "arithmetic":
  checkTypeAndCount(initSeconds(6) + initSeconds(9), Seconds, 15)
  checkTypeAndCount(initSeconds(5) + initMilliseconds(100), Milliseconds, 5100)

  checkTypeAndCount(initSeconds(6) - initSeconds(9), Seconds, -3)
  checkTypeAndCount(initSeconds(5) - initMilliseconds(100), Milliseconds, 4900)

test "conversions":
  check initSeconds(5).to(Milliseconds).count == 5000
  check initMilliseconds(3500).to(Seconds).count == 3
  check initMilliseconds(3500).to(Milliseconds).count == 3500

test "dollars":
  check $initSeconds(5) == "Seconds(5)"
  check $initMilliseconds(5) == "Milliseconds(5)"
  check $initDuration[Milli](5) == "Milliseconds(5)"
  check $initDuration[initRatio(22, 7)](5) == "Duration[22/7](5)"
