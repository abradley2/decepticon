pub type State(a, s) {
  State(run: fn(s) -> #(a, s))
}

pub fn state(run: fn(s) -> #(a, s)) -> State(a, s) {
  State(run)
}

pub fn action(a) -> State(a, s) {
  State(fn(s) { #(a, s) })
}

pub fn get() -> State(s, s) {
  State(fn(s) { #(s, s) })
}

pub fn put(s: s) -> State(Nil, s) {
  State(fn(_) { #(Nil, s) })
}

pub fn map(state: State(a, s), f: fn(a) -> b) -> State(b, s) {
  State(fn(s) {
    let #(a, s) = state.run(s)
    #(f(a), s)
  })
}

pub fn and_map(prev: State(fn(a) -> b, s), next: State(a, s)) -> State(b, s) {
  State(fn(s) {
    let #(f, s) = prev.run(s)
    let #(a, s) = next.run(s)
    #(f(a), s)
  })
}

pub fn and_then(state: State(a, s), f: fn(a) -> State(b, s)) -> State(b, s) {
  State(fn(s) {
    let #(a, s) = state.run(s)
    f(a).run(s)
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
  state(fn(s) { #(Nil, s + 1) })
}
