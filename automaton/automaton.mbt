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
} derive(Eq, Show, Compare, ToJson)

///|
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

  (dfs(self), state + 1)
}

///|
struct Transition(FixedArray[Map[Int, Set[Int]]]) derive(Eq, Show, ToJson)

///|
fn Transition::new(state_count : Int) -> Transition {
  Transition(FixedArray::makei(state_count, _ => Map::new()))
}

///|
fn Transition::add_transition(
  self : Transition,
  from : Int,
  sym : Int,
  to : Int,
) -> Unit {
  let edge = self.0[from]
  // edge.update()
  edge.update(sym, fn(set) {
    match set {
      None => Some(Set::new()..add(to))
      Some(set) => Some(set..add(to))
    }
  })
}

///|
fn symbol_to_letter(sym : Int) -> Char {
  match sym {
    0 => Epsilon
    1..=26 => Int::unsafe_to_char('a'.to_int() + sym - 1)
    _ => abort("invalid range")
  }
}

///|
fn letter_to_symbol(letter : Char) -> Int {
  match letter {
    'ε' => 0
    'a'..='z' => letter.to_int() - 'a'.to_int() + 1
    _ => abort("invalid range")
  }
}

///|
const Epsilon = 'ε'

///|
fn Transition::to_digraph(self : Transition) -> @graphviz.Digraph {
  let nodes = []
  let edges = []
  fn int_to_node(id : Int) {
    @graphviz.Node::{ id, label: Some(id.to_string()) }
  }

  fn mk_edge(from : Int, label : Char, to : Int) -> @graphviz.Edge {
    { from, to, label: Some(String::make(1, label)) }
  }

  fn connect(from : Int, sym : Int, to : Int) {
    edges.push(mk_edge(from, symbol_to_letter(sym), to))
  }

  fn add_fresh_state(s : Int) {
    nodes.push(int_to_node(s))
  }

  for initial, trans in self.0 {
    add_fresh_state(initial)
    for sym, finals in trans {
      for final in finals {
        connect(initial, sym, final)
      }
    }
  }
  { nodes, edges, rankdir: LeftToRight }
}

///|
struct Edge {
  initial : Int
  final : Int
}

///|
fn Regex::to_transition(regex : Regex) -> Transition {
  let (nfa, size) = regex.to_nfa_with_size()
  let transition = Transition::new(size)
  fn connect(from : Int, sym : Int, to : Int) {
    transition.add_transition(from, sym, to)
  }

  let eps = 0
  fn dfs(nfa : NFA) -> Edge {
    match nfa {
      Choice(initial~, top, bot, final~) => {
        let edge_top = dfs(top)
        let edge_bot = dfs(bot)
        connect(initial, eps, edge_top.initial)
        connect(initial, eps, edge_bot.initial)
        connect(edge_top.final, eps, final)
        connect(edge_bot.final, eps, final)
        Edge::{ initial, final }
      }
      Concat(left, right) => {
        let { initial, final: from } = dfs(left)
        let { initial: to, final } = dfs(right)
        connect(from, eps, to)
        Edge::{ initial, final }
      }
      Symbol(initial~, sym, final~) => {
        connect(initial, sym, final)
        Edge::{ initial, final }
      }
      Repeat(initial~, nfa, final~) => {
        let edge_nfa = dfs(nfa)
        connect(initial, eps, edge_nfa.initial)
        connect(edge_nfa.final, eps, edge_nfa.initial)
        connect(edge_nfa.final, eps, final)
        Edge::{ initial, final }
      }
    }
  }

  let { initial, .. } = dfs(nfa)
  connect(ToplevelInitialState, eps, initial)
  transition
}
