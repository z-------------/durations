import std/unittest
import durations
import ./funcs

template checkTypeAndCount(expr, expected: untyped) =
  let d = expr
  check d is typeof(expected)
  check d.count == expected.count

template `=~`(a, b: float): bool =
  abs(a - b) < 0.000001

test "arithmetic":
  checkTypeAndCount(6.seconds + 9.seconds, 15.seconds)
  checkTypeAndCount(5.seconds + 100.milliseconds, 5100.milliseconds)

  checkTypeAndCount(6.seconds - 9.seconds, (-3).seconds)
  checkTypeAndCount(5.seconds - 100.milliseconds, 4900.milliseconds)

  checkTypeAndCount(25.milliseconds * 3, 75.milliseconds)
  checkTypeAndCount(3 * 25.milliseconds, 75.milliseconds)
  checkTypeAndCount(25.milliseconds * 3.5, 87.milliseconds)
  checkTypeAndCount(3.5 * 25.milliseconds, 87.milliseconds)

  checkTypeAndCount(20.seconds div 4, 5.seconds)
  checkTypeAndCount(21.seconds div 4, 5.seconds)
  checkTypeAndCount(100.milliseconds div 3.3, 30.milliseconds)
  check 100.seconds div 33.milliseconds == 3030
  check 100.seconds / 33.milliseconds =~ 100_000 / 33

  checkTypeAndCount(1.hours + 59.minutes, (60 + 59).minutes)

test "comparisons":
  check 6.seconds != 5.seconds
  check 6.seconds > 5.seconds
  check 6.seconds >= 5.seconds
  check 5.seconds >= 5.seconds
  check 5.seconds == 5.seconds
  check 5.seconds <= 5.seconds
  check 4.seconds <= 5.seconds
  check 4.seconds < 5.seconds
  check 4.seconds != 5.seconds

  check 1000.milliseconds == 1.seconds
  check 240.minutes == 4.hours
  check 4.hours > 239.minutes

  check not (6.seconds == 5.seconds)
  check not (6.seconds < 5.seconds)
  check not (6.seconds <= 5.seconds)
  check not (5.seconds != 5.seconds)
  check not (4.seconds >= 5.seconds)
  check not (4.seconds > 5.seconds)
  check not (4.seconds == 5.seconds)

test "conversions":
  check 5.seconds.to(Milliseconds).count == 5000
  check 3500.milliseconds.to(Seconds).count == 3
  check 3500.milliseconds.to(Milliseconds).count == 3500

test "dollars":
  check $5.seconds == "5 seconds"
  check $5.milliseconds == "5 milliseconds"
  check $2.hours == "2 hours"
  check $initDuration[Milli](5) == "5 milliseconds"
  check $initDuration[initRatio(22, 7)](5) == "Duration[22/7](5)"

test "no implicit conversion unless enabled":
  check not compiles(getCountMilli(5.seconds))
