import decepticon/stateful.{type State} as state
import gleam/result

/// The main type of this library- which represents a `State` wrapping a `Result`.
/// See the `decepticon/stateful` module for standalone `State`
pub type StateResult(a, s, err) {
  StateResult(run: State(Result(a, err), s))
}

/// Given a `StateResult`, return the `Result` of the last executed action.
pub fn eval(st: StateResult(a, s, err), s: s) -> Result(a, err) {
  state.eval(st.run, s)
}

/// Given a `StateResult`, return the final version of the internal state.
pub fn exec(st: StateResult(a, s, err), s: s) -> s {
  state.exec(st.run, s)
}

/// Lift a `Result` into the `StateResult` type. Useful for when you have a
/// non-stateful action that is simply a `Result` and wish to weave it in 
/// as a `use` statement
pub fn try(a) {
  StateResult(run: state.action(a))
}

/// Lift a `Result`'s value argument into a `StateResult`
pub fn action(a) {
  StateResult(run: state.action(Ok(a)))
}

/// Lift a `Result`'s error argument into a `StateResult`
pub fn error(err) {
  StateResult(run: state.action(Error(err)))
}

/// Lift a `State` type into a `StateResult` type. Wrapping it's
/// action type in `result.Ok`
pub fn ok_state(state: State(a, s)) -> StateResult(a, s, err) {
  StateResult(run: state.map(state, fn(a) { Ok(a) }))
}

/// Lift a `State` type into a `StateResult` type. Wrapping it's
/// action type in `result.Error`
pub fn error_state(state: State(err, s)) -> StateResult(a, s, err) {
  StateResult(run: state.map(state, fn(err) { Error(err) }))
}

/// Return the current value of state
pub fn get() -> StateResult(s, s, err) {
  ok_state(state.get())
}

/// Set the current value of state
pub fn put(s) -> StateResult(Nil, s, err) {
  ok_state(state.put(s))
}

/// Map over the action type of a `StateResult`
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

/// Applicative Functor method for `StateResult`
pub fn apply(
  prev: StateResult(fn(a) -> b, s, err),
  next: StateResult(a, s, err),
) -> StateResult(b, s, err) {
  let combined =
    state.do(prev.run, fn(result_fn) {
      case result_fn {
        Ok(map_fn) -> {
          state.map(next.run, fn(arg) { result.map(arg, map_fn) })
        }
        Error(err) -> state.action(Error(err))
      }
    })
  StateResult(run: combined)
}

/// Map over the error type of a `StateResult`
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

/// The basic mechanism of chaining `StateResult` actions. This is most similar to `result.try`
pub fn do(
  over state_result: StateResult(a, s, err),
  with and_then_fn: fn(a) -> StateResult(b, s, err),
) -> StateResult(b, s, err) {
  StateResult(
    run: state.do(state_result.run, fn(a_result) {
      case a_result {
        Ok(a) -> and_then_fn(a).run
        Error(err) -> state.action(Error(err))
      }
    }),
  )
}
