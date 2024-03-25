pub type Reader(a, ctx) {
  Reader(run: fn(ctx) -> a)
}

pub fn pure(a) -> Reader(a, ctx) {
  Reader(run: fn(_) { a })
}

pub fn map(over: Reader(a, ctx), with: fn(a) -> b) -> Reader(b, ctx) {
  Reader(run: fn(ctx) { with(over.run(ctx)) })
}

pub fn and_then(
  over: Reader(a, ctx),
  with: fn(a) -> Reader(b, ctx),
) -> Reader(b, ctx) {
  Reader(run: fn(ctx) { with(over.run(ctx)).run(ctx) })
}

pub fn and_map(
  prev: Reader(fn(a) -> b, ctx),
  next: Reader(a, ctx),
) -> Reader(b, ctx) {
  Reader(run: fn(ctx) { prev.run(ctx)(next.run(ctx)) })
}
