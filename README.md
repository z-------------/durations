# durations

[![Pipeline status](https://gitlab.com/z-------------/durations/badges/master/pipeline.svg)](https://gitlab.com/z-------------/durations/pipelines)

Statically typed durations for Nim.

## What and why

Say you have a procedure that takes a duration in microseconds as an argument:

```nim
proc sleep(duration: int) =
  discard usleep(duration.cuint)
```

You can't tell what unit `duration` is supposed to be in from the parameter types, and there is nothing stopping you from passing the wrong unit. The following will sleep for 1000 *microseconds*, not milliseconds as intended:

```nim
let timeToSleepInMs = 1000
sleep(timeToSleepInMs)
```

You can solve both of these problems by using the durations library:

```nim
import pkg/durations

proc sleep(duration: Microseconds) =
  discard usleep(duration.count.cuint)
```

Now if you try to call `sleep` like this:

```nim
let timeToSleepInMs = 1000.milliseconds
sleep(timeToSleepInMs)
```

compilation fails with a type mismatch error:

```
Error: type mismatch
Expression: sleep(timeToSleepInMs)
  [1] timeToSleepInMs: Milliseconds

Expected one of (first mismatch at [position]):
[1] proc sleep(duration: Microseconds)
```

To be able to call the procedure, you must ensure your arguments are in the correct units. The following compiles and sleeps for the correct amount of time:

```nim
sleep(timeToSleepInMs.to(Microseconds))
```

If you find the manual conversion cumbersome, you can compile your program with `-d:durationsImplicitConversion`, which allows you to implicitly convert your durations to units of higher precision. If you do that, the following works:

```nim
sleep(timeToSleepInMs)
```

This library also has all the expected arithmetic and comparison operators, as well as a nice `$`:

```nim
echo 1.seconds + 250.milliseconds # prints "1250 milliseconds"
```

## Custom units

Duration types are implemented as instantiations of the generic type `Duration[R: static[Ratio]]`, where `Ratio` is a rational number. For example, `Seconds` is `Duration[1 // 1]` and `Milliseconds` is `Duration[1 // 1000]`.

The library comes with several units built in, including `Nanoseconds` and `Days`.

You can define a custom duration type like this:

```nim
import pkg/durations/unitdef

unit Mega, Megaseconds, 1_000_000 // 1
```

This generates:

* `const Mega: Ratio = 1_000_000 // 1`
* `type Megaseconds = Duration[Mega]`
* `n.megaseconds` initializer
* Implicit converters as described above if enabled

## License

Apache License, Version 2.0. See LICENSE.
