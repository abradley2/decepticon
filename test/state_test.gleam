import gleeunit/should
import decepticon/state.{type State, State}

pub fn increment_state() -> State(Nil, Int) {
  use current_count <- state.and_then(state.get())
  use _ <- state.and_then(state.put(current_count + 1))

  state.action(Nil)
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
