import std/rationals

type
  CountType* = int64
  Ratio* = Rational[CountType]
  Duration*[R: static[Ratio]] = object
    count*: CountType

func initDuration*[R: static[Ratio]](count: CountType): Duration[R] =
  result.count = count

func initRatio*(num, denom: CountType): Ratio =
  num // denom

func `$`*[R](d: Duration[R]): string =
  "Duration[" & $R & "](" & $d.count & ")"

template toCountType(x: Rational[CountType]): CountType =
  x.num div x.den

func to*[R1, R2](d1: Duration[R1]; outType: typedesc[Duration[R2]]): Duration[R2] =
  const conversion = R1 / R2
  result.count = (d1.count * conversion).toCountType
