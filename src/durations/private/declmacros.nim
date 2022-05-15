import std/genasts
import std/macros
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

func generateInits(typeName, ratio: NimNode): seq[NimNode] =
  result.add(generateInit(typeName, ratio))
  result.add(generateInitSugar(typeName))

macro generateDeclsFromTypes*(typeSectionStmtList: untyped): untyped =
  typeSectionStmtList.expectKind(nnkStmtList)
  result = newStmtList()
  result.add(typeSectionStmtList)

  let typeSection = typeSectionStmtList[0]
  typeSection.expectKind(nnkTypeSection)

  for typeDef in typeSection:
    let
      typeName = typeDef[0][1]
      ratio = typeDef[2][1]
    result.add(generateInits(typeName, ratio))
    result.add(generateDollar(typeName))

macro generateDecls*(constSectionStmtList: untyped): untyped =
  constSectionStmtList.expectKind(nnkStmtList)
  result = newStmtList()
  result.add(constSectionStmtList)

  let constSection = constSectionStmtList[0]
  constSection.expectKind(nnkConstSection)

  for constDef in constSection:
    let
      ratio = constDef[0][1]
      typeName = ident($ratio & "seconds")
    result.add(generateType(typeName, ratio))
    result.add(generateInits(typeName, ratio))
    result.add(generateDollar(typeName))
