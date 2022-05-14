import ./core
import ./private/declmacros
import std/math

generateDeclsFromTypes:
  type
    Seconds* = Duration[initRatio(1, 1)]

generateDecls:
  const
    Nano* = initRatio(1, 10 ^ 9)
    Micro* = initRatio(1, 10 ^ 6)
    Milli* = initRatio(1, 10 ^ 3)
