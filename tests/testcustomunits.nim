import std/unittest
import durations
import durations/unitdef
import ./funcs

unit Deca, Decaseconds, 10 // 1
unit Hecto, Hectoseconds, 100 // 1

func getCountDeca(d: Decaseconds): Count =
  d.count

test "can define custom units":
  check Decaseconds.init(50) == Seconds.init(50 * 10)
  check 123.decaseconds == Decaseconds.init(123)
  check Decaseconds.init(42) == 42.decaseconds
  check $Decaseconds.init(42) == "42 decaseconds"

  check 2.hectoseconds == 20.decaseconds
  check 2.hectoseconds == 200.seconds

test "custom units participate in implicit conversion":
  # custom -> builtin
  check getCountMilli(2.decaseconds) == 2 * 10 * 1000

  # builtin -> custom
  check getCountDeca(3.hours) == 3 * 60 * (60 div 10)

  # custom -> custom
  check getCountDeca(3.hectoseconds) == 30
