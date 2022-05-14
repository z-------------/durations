import ./core
import std/macros
import std/genasts
import std/math
import std/strutils

func generateType(typeName, ratio: NimNode): NimNode =
  genAst(typeName, ratio):
    type typeName* = Duration[ratio]

template getInitName(typeName: NimNode): NimNode =
  ident("init" & $typeName)

func generateInit(typeName, ratio: NimNode): NimNode =
  genAst(name = getInitName(typeName), typeName, ratio):
    func name*(count: Count): typeName =
      initDuration[ratio](count)

func generateInitSugar(typeName: NimNode): NimNode =
  let name = ident(($typeName).toLowerAscii)
  genAst(name, initName = getInitName(typeName), typeName):
    template name*(count: Count): typeName =
      initName(count)

func generateInits(typeName, ratio: NimNode): seq[NimNode] =
  result.add(generateInit(typeName, ratio))
  result.add(generateInitSugar(typeName))

func generateDollar(typeName: NimNode): NimNode =
  let typeNameLower = newLit(($typeName).toLowerAscii)
  genAst(typeName, typeNameLower):
    func `$`*(d: typeName): string =
      $d.count & ' ' & typeNameLower

macro generateDeclsFromTypes(typeSectionStmtList: untyped): untyped =
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

macro generateDecls(constSectionStmtList: untyped): untyped =
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

generateDeclsFromTypes:
  type
    Seconds* = Duration[initRatio(1, 1)]

generateDecls:
  const
    Nano* = initRatio(1, 10 ^ 9)
    Micro* = initRatio(1, 10 ^ 6)
    Milli* = initRatio(1, 10 ^ 3)
