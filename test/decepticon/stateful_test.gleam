import gleeunit/should
import decepticon/stateful.{action, do, exec, get, put}

pub fn increment_state() {
  use current_count <- do(get())
  put(current_count + 1)
}

pub fn increment_test() {
  let do_state = {
    use _ <- do(increment_state())
    use _ <- do(increment_state())
    use _ <- do(increment_state())
    action(Nil)
  }

  let result = exec(do_state, 0)

  should.equal(result, 3)
}
