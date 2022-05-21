# durations

Statically typed durations for Nim.

## What and why

Let's say you have a procedure that takes a duration in microseconds as an argument:

```nim
proc sleep(duration: int) =
  discard usleep(duration.cuint)
```

You don't know by looking at the parameter types what unit `duration` is supposed to be in, and there is nothing stopping you from passing the wrong unit. The following will sleep for 1000 *microseconds*, not milliseconds as intended:

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

compilation will fail with a type mismatch error:

```
Error: type mismatch: got <Milliseconds>
but expected one of:
proc sleep(duration: Microseconds)
  first type mismatch at position: 1
  required type for duration: Microseconds
  but expression 'initMilliseconds(1000)' is of type: Milliseconds
```

To be able to call the procedure, you must ensure your arguments are in the correct units. The following will compile and sleep for the correct amount of time:

```nim
let timeToSleepInMs = 1000.milliseconds
sleep(timeToSleepInMs.to(Microseconds))
```

If you find the manual conversion cumbersome, you can compile your program with `-d:durationsImplicitConversion`, which allows you to implicitly convert your durations to units of higher precision. If you do that, the following works:

```nim
sleep(timeToSleepInMs)
```

and the following still fails to compile, since nanoseconds are smaller than microseconds:

```nim
let timeToSleepInNs = 1_000_000_000.nanoseconds
sleep(timeToSleepInNs)
```

This library also has all the expected arithmetic and comparison operators, as well as a nice `$`:

```nim
echo 1.seconds + 250.milliseconds # prints "1250 milliseconds"
```

## License

Copyright 2022 Zack Guard

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
