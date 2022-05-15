import ./core
import ./private/declmacros
import std/math

generateDecls:
  const
    Nano* = initRatio(1, 10 ^ 9)
    Micro* = initRatio(1, 10 ^ 6)
    Milli* = initRatio(1, 10 ^ 3)
    Unit* = initRatio(1, 1)
