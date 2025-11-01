///|
pub fn Regex::to_nfac(self : Regex, initial~ : Int) -> NFAC {
  let initial_count = initial - 1
  let mut count = initial_count
  fn fresh() {
    count += 1
    count
  }

  fn dfs(self : Regex) -> RNFA {
    match self {
      Symbol(sym) => Symbol(initial=fresh(), sym, final_=fresh())
      Concat(left, right) => Concat(dfs(left), dfs(right))
      Choice(top, bot) =>
        Choice(initial=fresh(), dfs(top), dfs(bot), final_=fresh())
      Repeat(regex) => Repeat(initial=fresh(), dfs(regex), final_=fresh())
    }
  }

  { nfa: dfs(self), count: count - initial_count }
}

///|
pub fn Regex::thompson_construction(
  regex : Regex,
  initial~ : Int,
  alphabet_count~ : Int,
) -> NFA {
  let { nfa, count } = regex.to_nfac(initial~)
  let nfat = NFAT::new(count)
  fn connect(from : NFAS, sym : Label, to : NFAS) {
    nfat.add_transition(from, sym, to)
  }

  fn dfs(nfa : RNFA) -> Edge[NFAS] {
    match nfa {
      Choice(initial~, top, bot, final_~) => {
        let edge_top = dfs(top)
        let edge_bot = dfs(bot)
        connect(initial, Epsilon, edge_top.initial)
        connect(initial, Epsilon, edge_bot.initial)
        connect(edge_top.final_, Epsilon, final_)
        connect(edge_bot.final_, Epsilon, final_)
        Edge::{ initial, final_ }
      }
      Concat(left, right) => {
        let { initial, final_: from } = dfs(left)
        let { initial: to, final_ } = dfs(right)
        connect(from, Epsilon, to)
        Edge::{ initial, final_ }
      }
      Symbol(initial~, sym, final_~) => {
        connect(initial, sym, final_)
        Edge::{ initial, final_ }
      }
      Repeat(initial~, nfa, final_~) => {
        let edge_nfa = dfs(nfa)
        connect(initial, Epsilon, edge_nfa.initial)
        connect(edge_nfa.final_, Epsilon, edge_nfa.initial)
        connect(edge_nfa.final_, Epsilon, final_)
        Edge::{ initial, final_ }
      }
    }
  }

  let { initial, final_ } = dfs(nfa)
  { initial, final_, transition: nfat, alphabet_count }
}
