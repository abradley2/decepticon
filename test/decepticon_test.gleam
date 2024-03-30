import gleeunit
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

pub fn main() {
  gleeunit.main()
}

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
