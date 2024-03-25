# Decepticon - Extra Monads and Monad Transforms for Gleam

This is a work in progress. There is quite a bit of ground to cover here.

```gleam
pub fn increment_state() -> State(Nil, Int) {
  State(run: fn(s) { #(Nil, s + 1) })
}

pub fn increment_test() {
  let do_state = {
    use _ <- state.and_then(increment_state())
    use _ <- state.and_then(increment_state())
    use _ <- state.and_then(increment_state())
    state.action(Nil)
  }

  let result = state.exec(do_state, 0)

  should.equal(result, 3)
}
```

<!-- [![Package Version](https://img.shields.io/hexpm/v/shiny_state)](https://hex.pm/packages/shiny_state)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/shiny_state/) -->

<!-- ```sh
gleam add shiny_state
```
```gleam
import shiny_state

pub fn main() {
  // TODO: An example of the project in use
}
``` -->

<!-- Further documentation can be found at <https://hexdocs.pm/shiny_state>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
``` -->
