///|
enum Regex {
  Concat(Regex, Regex)
  Choice(Regex, Regex)
  Repeat(Regex)
  Symbol(Int)
} derive(Eq, Show, Compare, ToJson)

///|
enum NFA {
  Symbol(initial~ : Int, Int, final~ : Int)
  Concat(NFA, NFA)
  Choice(initial~ : Int, NFA, NFA, final~ : Int)
  Repeat(initial~ : Int, NFA, final~ : Int)
}

const ToplevelInitialState = 0

///|
fn Regex::to_nfa_with_size(self : Regex) -> (NFA, Int) {
  let mut state = ToplevelInitialState
  fn fresh() {
    state += 1
    state
  }

  fn dfs(self : Regex) -> NFA {
    match self {
      Symbol(sym) => Symbol(initial=fresh(), sym, final=fresh())
      Concat(left, right) => Concat(dfs(left), dfs(right))
      Choice(top, bot) =>
        Choice(initial=fresh(), dfs(top), dfs(bot), final=fresh())
      Repeat(regex) => Repeat(initial=fresh(), dfs(regex), final=fresh())
    }
  }

  (dfs(self), state - 1)
}
