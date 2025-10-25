///|
enum Regex {
  Concat(Regex, Regex)
  Choice(Regex, Regex)
  Repeat(Regex)
  Symbol(Int)
} derive(Eq, Show, Compare, ToJson)

///|
struct NFA {
  initial : Int
  regex : RNFA
  final : Int
} derive(Eq, Show, Compare, ToJson)

///|
enum RNFA {
  Concat(NFA, NFA)
  Choice(NFA, NFA)
  Repeat(NFA)
  Symbol(Int)
} derive(Eq, Show, Compare, ToJson)

///|
fn Regex::to_nfa(self : Regex) -> (NFA, Int) {
  let mut state = 0
  fn fresh() {
    state += 1
    state
  }

  fn dfs(self : Regex) -> NFA {
    match self {
      Symbol(sym) =>
        NFA::{ initial: fresh(), regex: Symbol(sym), final: fresh() }
      Concat(left, right) => {
        let nfa_left = dfs(left)
        let nfa_right = dfs(right)
        NFA::{
          initial: nfa_left.initial,
          regex: Concat(nfa_left, nfa_right),
          final: nfa_right.final,
        }
      }
      Choice(left, right) =>
        NFA::{
          initial: fresh(),
          regex: Choice(dfs(left), dfs(right)),
          final: fresh(),
        }
      Repeat(regex) =>
        NFA::{ initial: fresh(), regex: Repeat(dfs(regex)), final: fresh() }
    }
  }

  (dfs(self), state - 1)
}
