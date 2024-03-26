import gleeunit/should
import decepticon/context.{type Context}

pub type Env {
  Env(foo: String)
}

pub fn run_context() -> Context(Env, Env) {
  use e <- context.and_then(context.asks())

  context.pure(e)
}

pub fn reader_test() {
  let env = Env(foo: "bar")

  let do_reader = {
    use res <- context.and_then(run_context())
    context.pure(res)
  }

  should.equal(env, do_reader.run(env))
}
