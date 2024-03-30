# Decepticon - StateT/Result in Gleam

This library sort of presumes familiarity with `StateT` as it exists in languages
like Haskell and PureScript. If you are familiar with `StateT`, then great. 

[Otherwise I would recommend you try out Act](https://github.com/MystPi/act).

With Decepticon we can create "stateful" actions that succeed or fail.
```gleam
import gleeunit/should
import decepticon.{do, error, eval, get, put}

pub fn increment_succeed() {
  use count <- do(get())
  put(count + 1)
}

pub fn increment_fail() {
  use count <- do(get())
  use _ <- do(error("Oh no!"))
  put(count + 1)
}
```

Then we can chain these actions together in ways that can succeed
```gleam
pub fn succeed_test() {
  let run_state = {
    use _ <- do(increment_succeed())
    use _ <- do(increment_succeed())
    use _ <- do(increment_succeed())
    get()
  }

  let result = eval(run_state, 0)

  should.equal(result, Ok(3))
}
```

or fail:
```gleam
pub fn fail_test() {
  let run_state = {
    use _ <- do(increment_succeed())
    use _ <- do(increment_fail())
    use _ <- do(increment_succeed())
    get()
  }

  let result = eval(run_state, 0)

  should.be_error(result)
}
```
