import decepticon/state_result_t as state_result
import decepticon/state
import gleeunit/should

pub fn increment_succeed() {
  use count <- state_result.and_then(state_result.get())

  use inc_by <- state_result.and_then(state_result.succeed(1))

  state_result.put(count + inc_by)
}

pub fn increment_fail() {
  use count <- state_result.and_then(state_result.get())

  use inc_by <- state_result.and_then(state_result.error("Oh no!"))

  state_result.put(count + inc_by)
}

pub fn successful_sequence_test() {
  let do_state = {
    use _ <- state_result.and_then(increment_succeed())
    use _ <- state_result.and_then(increment_succeed())
    use _ <- state_result.and_then(increment_succeed())
    use _ <- state_result.and_then(increment_succeed())
    state_result.get()
  }

  let v = should.be_ok(state.eval(do_state.run, 0))
  should.equal(v, 4)
}

pub fn failed_sequence_test() {
  let do_state = {
    use _ <- state_result.and_then(increment_succeed())
    use _ <- state_result.and_then(increment_succeed())
    use _ <- state_result.and_then(increment_fail())
    use _ <- state_result.and_then(increment_succeed())
    state_result.get()
  }

  should.be_error(state.eval(do_state.run, 0))
}
