import ./core
import std/macros
import std/genasts
import std/math

func generateType(typeName, ratioType: NimNode): NimNode =
  genAst(typeName, ratioType):
    type typeName* = Duration[ratioType]

func generateInit(typeName, ratioType: NimNode): NimNode =
  let initProcName = ident("init" & $typeName)
  genAst(initProcName, typeName, ratioType):
    func initProcName*(count: Count): typeName =
      initDuration[ratioType](count)

func generateDollar(typeName: NimNode): NimNode =
  genAst(typeName):
    func `$`*(d: typeName): string =
      $typeName & "(" & $d.count & ")"

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
    result.add(generateInit(typeName, ratio))
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
    result.add(generateInit(typeName, ratio))
    result.add(generateDollar(typeName))

generateDeclsFromTypes:
  type
    Seconds* = Duration[initRatio(1, 1)]

generateDecls:
  const
    Nano* = initRatio(1, 10 ^ 9)
    Micro* = initRatio(1, 10 ^ 6)
    Milli* = initRatio(1, 10 ^ 3)
