import decepticon/context.{type Context, Context}
import decepticon/state.{type State}
import decepticon/state_result_t.{type StateResult, StateResult} as state_result

pub type ContextStateResult(a, ctx, s, err) {
  ContextStateResult(run: Context(StateResult(a, s, err), ctx))
}

pub fn succeed(a: a) -> ContextStateResult(a, ctx, s, err) {
  ContextStateResult(run: Context(run: fn(_) { state_result.succeed(a) }))
}

pub fn error(e: err) -> ContextStateResult(a, ctx, s, err) {
  ContextStateResult(run: Context(run: fn(_) { state_result.error(e) }))
}

pub fn ok_state(s: State(a, s)) -> ContextStateResult(a, ctx, s, err) {
  ContextStateResult(
    run: Context(run: fn(_) { StateResult(run: state.map(s, Ok)) }),
  )
}

pub fn error_state(s: State(err, s)) -> ContextStateResult(a, ctx, s, err) {
  ContextStateResult(
    run: Context(run: fn(_) { StateResult(run: state.map(s, Error)) }),
  )
}

pub fn ask() -> ContextStateResult(ctx, ctx, s, err) {
  ContextStateResult(run: Context(run: fn(ctx) { state_result.succeed(ctx) }))
}

pub fn get() -> ContextStateResult(s, ctx, s, err) {
  ContextStateResult(run: Context(run: fn(_) { state_result.get() }))
}

pub fn put(s: s) -> ContextStateResult(Nil, ctx, s, err) {
  ContextStateResult(run: Context(run: fn(_) { state_result.put(s) }))
}

pub fn map(
  over: ContextStateResult(a, ctx, s, err),
  with: fn(a) -> b,
) -> ContextStateResult(b, ctx, s, err) {
  ContextStateResult(run: context.map(over.run, state_result.map(_, with)))
}

pub fn map_error(
  over: ContextStateResult(a, ctx, s, err1),
  with: fn(err1) -> err2,
) -> ContextStateResult(a, ctx, s, err2) {
  ContextStateResult(
    run: context.map(over.run, state_result.map_error(_, with)),
  )
}

pub fn and_then(
  over: ContextStateResult(a, ctx, s, err),
  with: fn(a) -> ContextStateResult(b, ctx, s, err),
) -> ContextStateResult(b, ctx, s, err) {
  ContextStateResult(
    run: Context(run: fn(ctx) {
      state_result.and_then(over.run.run(ctx), fn(a) { with(a).run.run(ctx) })
    }),
  )
}

pub fn and_map(
  prev: ContextStateResult(fn(a) -> b, ctx, s, err),
  next: ContextStateResult(a, ctx, s, err),
) {
  ContextStateResult(
    run: Context(run: fn(ctx) {
      state_result.and_map(prev.run.run(ctx), next.run.run(ctx))
    }),
  )
}
