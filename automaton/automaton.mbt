///|
fn Regex::to_nfac(self : Regex, initial~ : Int) -> NFAC {
  let initial_count = initial - 1
  let mut count = initial_count
  fn fresh() {
    count += 1
    count
  }

  fn dfs(self : Regex) -> RNFA {
    match self {
      Symbol(sym) => Symbol(initial=fresh(), sym, final=fresh())
      Concat(left, right) => Concat(dfs(left), dfs(right))
      Choice(top, bot) =>
        Choice(initial=fresh(), dfs(top), dfs(bot), final=fresh())
      Repeat(regex) => Repeat(initial=fresh(), dfs(regex), final=fresh())
    }
  }

  { nfa: dfs(self), count: count - initial_count }
}

///|
fn Regex::to_nfa(regex : Regex, initial~ : Int) -> NFA {
  let toplevel_initial = initial
  let { nfa, count } = regex.to_nfac(initial~)
  let nfat = NFAT::new(count)
  fn connect(from : Int, sym : Int, to : Int) {
    nfat.add_transition(from, sym, to)
  }

  let eps = 0
  fn dfs(nfa : RNFA) -> Edge {
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

  let { initial, final } = dfs(nfa)
  { initial, final, nfat }
}

///|
fn NFAT::new(count : Int) -> NFAT {
  NFAT(FixedArray::makei(count, _ => Map::new()))
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

// ///|
// fn DFA::new(initial~ : DFAS, finals~ : Set[DFAS]) -> DFA {
//   DFA::{ initial, dfat: Map::new(), finals }
// }

///|
fn DFAT::add_transition(dfat : DFAT, from : DFAS, sym : Int, to : DFAS) -> Unit {
  fn connect(edge : Map[Int, DFAS]) -> Map[Int, DFAS]? {
    edge.update(sym, fn(dfa_state) {
      match dfa_state {
        None => Some(to)
        Some(dead) if dead.0.is_empty() => Some(dead)
        Some(to_) if to_ == to => Some(to)
        Some(_) => abort("impossible")
      }
    })
    Some(edge)
  }

  dfat.0.update(from, fn(edge) {
    match edge {
      Some(edge) => connect(edge)
      None => connect({})
    }
  })
}

///|
fn NFA::powerset_construction(nfa : NFA, alphatbet_count : Int) -> DFA {
  let nfat = nfa.nfat
  let pending = []
  let dfa_initial : DFAS = nfat.epsilon_closure(Set::new()..add(nfa.initial))
  let dfa_finals : Set[DFAS] = Set::new()
  let dfat : DFAT = Map::new()
  pending.push(dfa_initial)
  fn connect(from : DFAS, sym : Int, to : DFAS) {
    dfat.add_transition(from, sym, to)
  }

  while pending.pop() is Some(dfs_state) {
    for sym in 1..<alphatbet_count {
      let new_dfa_state = nfat.epsilon_closure(nfat.move(dfs_state.0, sym))
      if new_dfa_state.contains(nfa.final) {
        dfa_finals.add(new_dfa_state)
      }
      connect(dfs_state, sym, new_dfa_state)
      if !dfat.0.contains(new_dfa_state) {
        pending.push(new_dfa_state)
      }
    }
  }
  DFA::{ initial: dfa_initial, finals: dfa_finals, dfat }
}

///|
fn DFA::to_digraph(
  self : DFA,
  symbol_to_letter~ : (Int) -> Char,
) -> @graphviz.Digraph {
  let map : Map[DFAS, Int] = {}
  let mut count = 0
  for dfs_state, _ in self.dfat.0 {
    map[dfs_state] = count
    count += 1
  }
  map[self.initial] = 0
  let nodes = []
  let edges = []
  fn state_to_node(s : DFAS) {
    let id = map[s]
    // let label = s.0.iter().to_string()
    let label = if id == 0 { "S" } else { id.to_string() }
    @graphviz.Node::{ id, label: Some(label) }
  }

  fn mk_edge(from : DFAS, label : Char, to : DFAS) -> @graphviz.Edge {
    let from = map[from]
    let to = map[to]
    { from, to, label: Some(String::make(1, label)) }
  }

  fn connect(from : DFAS, sym : Int, to : DFAS) {
    edges.push(mk_edge(from, symbol_to_letter(sym), to))
  }

  fn add_fresh_state(s : DFAS) {
    if !s.0.is_empty() {
      nodes.push(state_to_node(s))
    } else {
      nodes.push(@graphviz.Node::{ id: map[s], label: Some("E") })
    }
  }

  for initial, trans in self.dfat.0 {
    add_fresh_state(initial)
    if !initial.0.is_empty() {
      for sym, final in trans {
        connect(initial, sym, final)
      }
    }
  }
  { nodes, edges, rankdir: LeftToRight }
}

///|
fn RNFA::to_digraph(
  nfa : RNFA,
  symbol_to_letter~ : (Int) -> Char,
) -> @graphviz.Digraph {
  let nodes : Array[@graphviz.Node] = []
  let edges : Array[@graphviz.Edge] = []
  fn int_to_node(id : Int) {
    @graphviz.Node::{ id, label: Some(id.to_string()) }
  }

  fn mk_edge(from : Int, label : Char, to : Int) -> @graphviz.Edge {
    { from, to, label: Some(String::make(1, label)) }
  }

  fn connect(from : Int, label : Char, to : Int) {
    edges.push(mk_edge(from, label, to))
  }

  fn add_fresh_state(initial : Int, final : Int) {
    nodes.push(int_to_node(initial))
    nodes.push(int_to_node(final))
  }

  fn dfs(nfa : RNFA) -> Edge {
    match nfa {
      Choice(initial~, top, bot, final~) => {
        add_fresh_state(initial, final)
        let edge_top = dfs(top)
        let edge_bot = dfs(bot)
        connect(initial, Epsilon, edge_top.initial)
        connect(initial, Epsilon, edge_bot.initial)
        connect(edge_top.final, Epsilon, final)
        connect(edge_bot.final, Epsilon, final)
        Edge::{ initial, final }
      }
      Concat(left, right) => {
        let { initial, final: from } = dfs(left)
        let { initial: to, final } = dfs(right)
        connect(from, Epsilon, to)
        Edge::{ initial, final }
      }
      Symbol(initial~, sym, final~) => {
        add_fresh_state(initial, final)
        connect(initial, symbol_to_letter(sym), final)
        Edge::{ initial, final }
      }
      Repeat(initial~, nfa, final~) => {
        add_fresh_state(initial, final)
        let edge_nfa = dfs(nfa)
        connect(initial, Epsilon, edge_nfa.initial)
        connect(edge_nfa.final, Epsilon, edge_nfa.initial)
        connect(edge_nfa.final, Epsilon, final)
        Edge::{ initial, final }
      }
    }
  }

  let { initial, .. } = dfs(nfa)
  let ipos = edges.search_by(edge => edge.from == initial).unwrap()
  edges.swap(0, ipos)
  @graphviz.Digraph::{ nodes, edges, rankdir: LeftToRight }
}

///|
fn NFAT::to_digraph(
  self : NFAT,
  symbol_to_letter~ : (Int) -> Char,
) -> @graphviz.Digraph {
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
