# Copyright 2022 Zack Guard
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import std/rationals

export rationals.`*`

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

template operatorImpl[R1, R2](d1: Duration[R1]; d2: Duration[R2]; expression: untyped; wrap = false): untyped =
  const commonRatio =
    when R2 < R1:
      R2
    else:
      R1
  let
    a {.inject.} = d1.to(Duration[commonRatio]).count
    b {.inject.} = d2.to(Duration[commonRatio]).count
  when wrap:
    initDuration[commonRatio](expression)
  else:
    expression

template arithImpl[R1, R2](d1: Duration[R1]; d2: Duration[R2]; expression: untyped): untyped =
  operatorImpl(d1, d2, expression, true)

func `+`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): auto =
  arithImpl(d1, d2, a + b)

func `-`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): auto =
  arithImpl(d1, d2, a - b)

func `*`*[R](d: Duration[R]; n: SomeInteger): Duration[R] =
  initDuration[R](d.count * n)

func `*`*[R; N: SomeFloat](d: Duration[R]; n: N): Duration[R] =
  initDuration[R]((d.count.N * n).Count)

func `*`*[R](n: SomeNumber; d: Duration[R]): Duration[R] =
  d * n

func `div`*[R](d: Duration[R]; n: SomeInteger): Duration[R] =
  initDuration[R](d.count div n)

func `div`*[R; N: SomeFloat](d: Duration[R]; n: N): Duration[R] =
  initDuration[R]((d.count.N / n).Count)

func `div`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): Count =
  operatorImpl(d1, d2, a div b)

func `/`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): float =
  operatorImpl(d1, d2, a.float / b.float)

func `==`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): bool =
  operatorImpl(d1, d2, a == b)

func `<=`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): bool =
  operatorImpl(d1, d2, a <= b)

func `<`*[R1, R2](d1: Duration[R1]; d2: Duration[R2]): bool =
  operatorImpl(d1, d2, a < b)
