import decepticon/state.{type State} as state
import gleam/result

pub type StateResult(a, s, err) {
  StateResult(run: State(Result(a, err), s))
}

pub fn succeed(a) {
  StateResult(run: state.action(Ok(a)))
}

pub fn error(err) {
  StateResult(run: state.action(Error(err)))
}

pub fn ok_state(state: State(a, s)) -> StateResult(a, s, err) {
  StateResult(run: state.map(state, fn(a) { Ok(a) }))
}

pub fn error_state(state: State(err, s)) -> StateResult(a, s, err) {
  StateResult(run: state.map(state, fn(err) { Error(err) }))
}

pub fn get() -> StateResult(s, s, err) {
  ok_state(state.get())
}

pub fn put(s) -> StateResult(Nil, s, err) {
  ok_state(state.put(s))
}

pub fn map(
  over state_result: StateResult(a, s, err),
  with map_fn: fn(a) -> b,
) -> StateResult(b, s, err) {
  StateResult(
    run: state.map(state_result.run, fn(a_result) {
      result.map(a_result, map_fn)
    }),
  )
}

pub fn and_map(
  prev: StateResult(fn(a) -> b, s, err),
  next: StateResult(a, s, err),
) -> StateResult(b, s, err) {
  let combined =
    state.and_then(prev.run, fn(result_fn) {
      case result_fn {
        Ok(map_fn) -> {
          state.map(next.run, fn(arg) { result.map(arg, map_fn) })
        }
        Error(err) -> state.action(Error(err))
      }
    })
  StateResult(run: combined)
}

pub fn map_error(
  over state_result: StateResult(a, s, err),
  with map_error_fn: fn(err) -> err2,
) -> StateResult(a, s, err2) {
  StateResult(
    run: state.map(state_result.run, fn(a_result) {
      result.map_error(a_result, map_error_fn)
    }),
  )
}

pub fn and_then(
  over state_result: StateResult(a, s, err),
  with and_then_fn: fn(a) -> StateResult(b, s, err),
) -> StateResult(b, s, err) {
  StateResult(
    run: state.and_then(state_result.run, fn(a_result) {
      case a_result {
        Ok(a) -> and_then_fn(a).run
        Error(err) -> state.action(Error(err))
      }
    }),
  )
}
