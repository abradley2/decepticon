pub type State(a, s) {
  State(run: fn(s) -> #(a, s))
}

pub fn action(action_value: a) -> State(a, s) {
  State(fn(s) { #(action_value, s) })
}

pub fn get() -> State(s, s) {
  State(fn(s) { #(s, s) })
}

pub fn put(state_value: s) -> State(Nil, s) {
  State(fn(_) { #(Nil, state_value) })
}

pub fn map(over state: State(a, s), with map_fn: fn(a) -> b) -> State(b, s) {
  State(fn(s) {
    let #(a, s) = state.run(s)
    #(map_fn(a), s)
  })
}

pub fn apply(prev: State(fn(a) -> b, s), next: State(a, s)) -> State(b, s) {
  State(fn(s) {
    let #(f, s) = prev.run(s)
    let #(a, s) = next.run(s)
    #(f(a), s)
  })
}

pub fn do(
  over state: State(a, s),
  with and_then_fn: fn(a) -> State(b, s),
) -> State(b, s) {
  State(fn(s) {
    let #(a, s) = state.run(s)
    and_then_fn(a).run(s)
  })
}

pub fn run(state: State(a, s), initial: s) -> #(a, s) {
  state.run(initial)
}

pub fn eval(state: State(a, s), initial: s) -> a {
  let #(a, _) = run(state, initial)
  a
}

pub fn exec(state: State(a, s), initial: s) -> s {
  let #(_, s) = run(state, initial)
  s
}

pub fn increment_state() -> State(Nil, Int) {
  State(run: fn(s) { #(Nil, s + 1) })
}
