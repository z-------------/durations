import ../core
import std/genasts
import std/macros
import std/rationals
import std/sequtils
import std/strutils
import std/tables

var units {.compileTime.}: Table[Ratio, NimNode]

template getInitName(typeName: NimNode): NimNode =
  ident("init" & $typeName)

func generateConst(ratioName: NimNode; ratio: Ratio): NimNode =
  genAst(ratioName, ratio):
    const ratioName* = ratio

func generateType(typeName, ratioName: NimNode): NimNode =
  genAst(typeName, ratioName):
    type typeName* = Duration[ratioName]

func generateInit(typeName, ratioName: NimNode): NimNode =
  genAst(name = getInitName(typeName), typeName, ratioName):
    func name*(count {.inject.}: Count): typeName =
      initDuration[ratioName](count)

func generateInitSugar(typeName: NimNode): NimNode =
  let name = ident(($typeName).toLowerAscii)
  genAst(name, initName = getInitName(typeName), typeName):
    template name*(count {.inject.}: Count): typeName =
      initName(count)

func generateDollar(typeName: NimNode): NimNode =
  let typeNameLower = newLit(($typeName).toLowerAscii)
  genAst(typeName, typeNameLower):
    func `$`*(d {.inject.}: typeName): string =
      $d.count & ' ' & typeNameLower

when defined(durationsImplicitConversion):
  import std/enumerate

  func generateConverter(name: NimNode; R1, R2: NimNode): NimNode =
    genAst(name, R1, R2):
      converter name*(d {.inject.}: Duration[R1]): Duration[R2] =
        d.to(Duration[R2])

  macro generateImplicitConverters*(): untyped =
    result = newStmtList()
    for i, r1 in enumerate(units.keys):
      for j, r2 in enumerate(units.keys):
        let
          name1 = units[r1]
          name2 = units[r2]
        if i != j and r1 >= r2:
          let converterName = ident("implicit" & name1.strVal & "To" & name2.strVal)
          result.add generateConverter(converterName, name1, name2)
else:
  macro generateImplicitConverters*() = discard

func generateInits(typeName, ratioName: NimNode): seq[NimNode] =
  result.add generateInit(typeName, ratioName)
  result.add generateInitSugar(typeName)

macro unit*(name: untyped; ratio: static[Ratio]): untyped =
  result = newStmtList()
  let typeName =
    if name.eqIdent("Unit"):
      ident("Seconds")
    else:
      ident(name.strVal & "seconds")
  result.add generateConst(name, ratio)
  result.add generateType(typeName, name)
  result.add generateInits(typeName, name)
  result.add generateDollar(typeName)

  units[ratio] = name

