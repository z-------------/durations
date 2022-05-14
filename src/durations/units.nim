import ./core
import std/macros
import std/genasts

func generateInit(typeName, ratioType: NimNode): NimNode =
  let initProcName = ident("init" & $typeName)
  genAst(initProcName, ratioType, typeName):
    func initProcName*(count: CountType): typeName =
      initDuration[ratioType](count)

func generateDollar(typeName: NimNode): NimNode =
  genAst(typeName):
    func `$`*(d: typeName): string =
      $typeName & "(" & $d.count & ")"

macro generateProcs(typeSectionStmtList: untyped): untyped =
  typeSectionStmtList.expectKind(nnkStmtList)
  result = newStmtList()
  result.add(typeSectionStmtList)
  let typeSection = typeSectionStmtList[0]
  for typeDef in typeSection:
    let
      typeName = typeDef[0][1]
      ratioType = typeDef[2][1]
    result.add(generateInit(typeName, ratioType))
    result.add(generateDollar(typeName))

const
  Milli* = initRatio(1, 1000)

generateProcs:
  type
    Milliseconds* = Duration[Milli]
    Seconds* = Duration[initRatio(1, 1)]

# TODO generate the Duration types, incl. their associated procs, from the Ratio consts
