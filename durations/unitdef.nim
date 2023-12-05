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

## This module contains the macro for defining new units. You don't need to
## import it unless you want to define your own custom units.

import ./core
import std/[
  genasts,
  macros,
  rationals,
  strutils,
  tables,
]

func generateConst(ratioName: NimNode; ratio: Ratio): NimNode =
  genAst(ratioName, ratio):
    const ratioName* = ratio

func generateType(typeName, ratioName: NimNode): NimNode =
  genAst(typeName, ratioName):
    type typeName* = Duration[ratioName]

func generateInitSugar(typeName: NimNode): NimNode =
  let name = ident(($typeName).toLowerAscii)
  genAst(name, typeName):
    template name*(count {.inject.}: Count): typeName =
      init(typeName, count)

func generateDollar(typeName: NimNode): NimNode =
  let typeNameLower = newLit(($typeName).toLowerAscii)
  genAst(typeName, typeNameLower):
    func `$`*(d {.inject.}: typeName): string =
      $d.count & ' ' & typeNameLower

when defined(durationsImplicitConversion):
  import std/[
    macrocache,
    sequtils,
  ]

  const mcUnits = CacheTable"durationsImplicitConversionUnits"

  func generateConverter(name: NimNode; R1, R2: NimNode): NimNode =
    genAst(name, R1, R2):
      converter name*(d {.inject.}: Duration[R1]): Duration[R2] =
        d.to(Duration[R2])

  proc generateImplicitConverter(name1, name2: NimNode): NimNode =
    let converterName = ident("implicit" & name1.strVal & "To" & name2.strVal)
    generateConverter(converterName, name1, name2)

  proc generateImplicitConverters(ratio: Ratio; ratioName: NimNode): seq[NimNode] =
    for r1Str, name1 in mcUnits.pairs:
      let
        split = r1Str.split('/').mapIt(it.parseInt.int64)
        r1 = split[0] // split[1]
      if r1 >= ratio:
        result.add generateImplicitConverter(name1, ratioName)
      if ratio >= r1:
        result.add generateImplicitConverter(ratioName, name1)
    mcUnits[$ratio] = ratioName

macro unit*(ratioName, typeName: untyped; ratio: static[Ratio]): untyped =
  result = newStmtList()

  result.add generateConst(ratioName, ratio)
  result.add generateType(typeName, ratioName)
  result.add generateInitSugar(typeName)
  result.add generateDollar(typeName)
  when defined(durationsImplicitConversion):
    result.add generateImplicitConverters(ratio, ratioName)
