import ./core
import ./private/declmacros
import std/math

unit Nano, initRatio(1, 10 ^ 9)
unit Micro, initRatio(1, 10 ^ 6)
unit Milli, initRatio(1, 10 ^ 3)
unit Unit, initRatio(1, 1)

generateImplicitConverters()
