pub type Context(a, ctx) {
  Context(run: fn(ctx) -> a)
}

pub fn asks() -> Context(ctx, ctx) {
  Context(run: fn(ctx) { ctx })
}

pub fn pure(a) -> Context(a, ctx) {
  Context(run: fn(_) { a })
}

pub fn map(over: Context(a, ctx), with: fn(a) -> b) -> Context(b, ctx) {
  Context(run: fn(ctx) { with(over.run(ctx)) })
}

pub fn and_then(
  over: Context(a, ctx),
  with: fn(a) -> Context(b, ctx),
) -> Context(b, ctx) {
  Context(run: fn(ctx) { with(over.run(ctx)).run(ctx) })
}

pub fn and_map(
  prev: Context(fn(a) -> b, ctx),
  next: Context(a, ctx),
) -> Context(b, ctx) {
  Context(run: fn(ctx) { prev.run(ctx)(next.run(ctx)) })
}
