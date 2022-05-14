import std/rationals

type
  Count* = int64
  Ratio* = Rational[Count]
  Duration*[R: static[Ratio]] = object
    count*: Count

func initDuration*[R: static[Ratio]](count: Count): Duration[R] =
  result.count = count

func initRatio*(num, denom: Count): Ratio =
  num // denom

func `$`*[R](d: Duration[R]): string =
  "Duration[" & $R & "](" & $d.count & ")"

func toCount(x: Rational[Count]): Count =
  x.num div x.den

func to*[R1, R2](d1: Duration[R1]; outType: typedesc[Duration[R2]]): Duration[R2] =
  when R1 == R2:
    result.count = d1.count
  else:
    const conversion = R1 / R2
    result.count = (d1.count * conversion).toCount
