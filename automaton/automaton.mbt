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
struct NFAT(FixedArray[Map[Int, Set[Int]]]) derive(Eq, Show, ToJson)

///|
fn NFAT::new(state_count : Int) -> NFAT {
  NFAT(FixedArray::makei(state_count, _ => Map::new()))
}

///|
fn NFAT::add_transition(self : NFAT, from : Int, sym : Int, to : Int) -> Unit {
  let edge = self.0[from]
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
fn NFAT::to_digraph(self : NFAT) -> @graphviz.Digraph {
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
fn NFAT::trans(self : NFAT, from : Int, sym : Int) -> Set[Int] {
  let edges = self.0[from]
  match self.0.get(from) {
    Some(from) =>
      match edges.get(sym) {
        Some(to) => to
        None => Set::new()
      }
    None => Set::new()
  }
  // edges[sym]
}

///|
fn NFAT::epsilon_closure(nfat : NFAT, initials : Set[Int]) -> Set[Int] {
  let result = initials.copy()
  let pending = initials.to_array()
  let eps = 0
  while pending.pop() is Some(initial) {
    for final in nfat.trans(initial, 0) {
      if !result.contains(final) {
        result.add(final)
        pending.push(final)
      }
    }
  }
  result
}

///|
fn NFAT::move(nfat : NFAT, initials : Set[Int], sym : Int) -> Set[Int] {
  let result = Set::new()
  for initial in initials {
    for final in nfat.trans(initial, sym) {
      result.add(final)
    }
  }
  result
}

///|
struct Edge {
  initial : Int
  final : Int
}

///|
fn Regex::to_transition(regex : Regex) -> NFAT {
  let (nfa, size) = regex.to_nfa_with_size()
  let transition = NFAT::new(size)
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

///|
struct DFAState(Set[Int]) derive(Eq, ToJson, Show)

///|
impl Hash for DFAState with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
struct DFA {
  initial : DFAState
  transition : Map[DFAState, Map[Int, DFAState]]
} derive(ToJson, Show)

///|
fn DFA::new(initial~ : DFAState) -> DFA {
  DFA::{ initial, transition: Map::new() }
}

///|
fn DFA::add_transition(
  self : DFA,
  from : DFAState,
  sym : Int,
  to : DFAState,
) -> Unit {
  self.transition.update(from, fn(edge) {
    match edge {
      Some(edge) => {
        edge.update(sym, fn(dfa_state) {
          match dfa_state {
            None => Some(to)
            Some(_) => abort("impossible")
          }
        })
        Some(edge)
      }
      None => {
        let edge = {}
        edge.update(sym, fn(dfa_state) {
          match dfa_state {
            None => Some(to)
            Some(_) => abort("impossible")
          }
        })
        Some(edge)
      }
    }
  })
}

///|
fn NFAT::powerset_construction(nfat : NFAT, alphatbet_count : Int) -> DFA {
  let pending = []
  let dfa_initial : DFAState = nfat.epsilon_closure(Set::new()..add(0))
  let dfa = DFA::new(initial=dfa_initial)
  pending.push(dfa_initial)
  fn connect(from : DFAState, sym : Int, to : DFAState) {
    dfa.add_transition(from, sym, to)
  }

  while pending.pop() is Some(dfs_state) {
    for sym in 1..<alphatbet_count {
      let new_dfa_state = nfat.epsilon_closure(nfat.move(dfs_state.0, sym))
      connect(dfs_state, sym, new_dfa_state)
      if !dfa.transition.contains(new_dfa_state) {
        pending.push(new_dfa_state)
      }
    }
  }
  dfa
}

///|
fn DFA::to_digraph(self : DFA) -> @graphviz.Digraph {
  let map : Map[DFAState, Int] = {}
  let mut count = 0
  for dfs_state, _ in self.transition {
    map[dfs_state] = count
    count += 1
  }
  map[self.initial] = 0
  let nodes = []
  let edges = []
  fn state_to_node(s : DFAState) {
    let id = map[s]
    // let label = s.0.iter().to_string()
    let label = if id == 0 { "S" } else { id.to_string() }
    @graphviz.Node::{ id, label: Some(label) }
  }

  fn mk_edge(from : DFAState, label : Char, to : DFAState) -> @graphviz.Edge {
    let from = map[from]
    let to = map[to]
    { from, to, label: Some(String::make(1, label)) }
  }

  fn connect(from : DFAState, sym : Int, to : DFAState) {
    edges.push(mk_edge(from, symbol_to_letter(sym), to))
  }

  fn add_fresh_state(s : DFAState) {
    if !s.0.is_empty() {

    nodes.push(state_to_node(s))
    } else {
      nodes.push(@graphviz.Node::{ id: map[s],label:Some("E")})
    }
  }

  for initial, trans in self.transition {
    add_fresh_state(initial)
    if !initial.0.is_empty() {
      for sym, final in trans {
        connect(initial, sym, final)
      }
    }
  }
  { nodes, edges, rankdir: LeftToRight }
}
