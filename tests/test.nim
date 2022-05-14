import durations
import std/unittest

test "conversions":
  check initSeconds(5).to(Milliseconds).count == 5000
  check initMilliseconds(3500).to(Seconds).count == 3
  check initMilliseconds(3500).to(Milliseconds).count == 3500

test "dollars":
  check $initSeconds(5) == "Seconds(5)"
  check $initMilliseconds(5) == "Milliseconds(5)"
  check $initDuration[Milli](5) == "Milliseconds(5)"
  check $initDuration[initRatio(22, 7)](5) == "Duration[22/7](5)"
