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

func toCount(x: Ratio): Count =
  x.num div x.den

func to*[R1, R2](d: Duration[R1]; outType: typedesc[Duration[R2]]): Duration[R2] =
  when R1 == R2:
    result.count = d.count
  else:
    const conversion = R1 / R2.Ratio # ???
    result.count = (d.count * conversion).toCount

template arithImpl[R1, R2](d1: Duration[R1]; d2: Duration[R2]; arithExpr: untyped): untyped =
  const commonRatio =
    when R2 < R1:
      R2
    else:
      R1
  let
    a {.inject.} = d1.to(Duration[commonRatio]).count
    b {.inject.} = d2.to(Duration[commonRatio]).count
  initDuration[commonRatio](arithExpr)

func `+`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): auto =
  arithImpl(d1, d2, a + b)

func `-`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): auto =
  arithImpl(d1, d2, a - b)
