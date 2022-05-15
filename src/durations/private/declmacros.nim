import std/genasts
import std/macros
import std/rationals
import std/sequtils
import std/strutils

template getInitName(typeName: NimNode): NimNode =
  ident("init" & $typeName)

func generateType(typeName, ratio: NimNode): NimNode =
  genAst(typeName, ratio):
    type typeName* = Duration[ratio]

func generateInit(typeName, ratio: NimNode): NimNode =
  genAst(name = getInitName(typeName), typeName, ratio):
    func name*(count {.inject.}: Count): typeName =
      initDuration[ratio](count)

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
  func generateConverter(name, R1, R2: NimNode): NimNode =
    genAst(name, R1, R2):
      when R1 < R2:
        discard
      else:
        converter name*(d {.inject.}: Duration[R1]): Duration[R2] =
          d.to(Duration[R2])

func generateInits(typeName, ratio: NimNode): seq[NimNode] =
  result.add(generateInit(typeName, ratio))
  result.add(generateInitSugar(typeName))

macro generateDecls*(constSectionStmtList: untyped): untyped =
  constSectionStmtList.expectKind(nnkStmtList)
  result = newStmtList()

  let constSection = constSectionStmtList[0]
  constSection.expectKind(nnkConstSection)
  result.add(constSection)

  for constDef in constSection:
    let
      ratio = constDef[0][1]
      typeName =
        if $ratio == "Unit":
          ident("Seconds")
        else:
          ident($ratio & "seconds")
    result.add(generateType(typeName, ratio))
    result.add(generateInits(typeName, ratio))
    result.add(generateDollar(typeName))

  when defined(durationsImplicitConversion):
    let constDefs = constSection.items.toSeq
    for i in 0..constDefs.high:
      for j in 0..constDefs.high:
        if i != j:
          let
            R1 = constDefs[i][0][1]
            R2 = constDefs[j][0][1]
            converterName = ident("implicit" & $R1 & "To" & $R2)
          result.add(generateConverter(converterName, R1, R2))
