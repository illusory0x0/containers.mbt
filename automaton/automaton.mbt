///|
fn set_singleton(val : Int) -> Set[Int] {
  let s = Set::new()
  s.add(val)
  s
}

///|
fn set_add(set : Set[Int], val : Int) -> Set[Int] {
  set.add(val)
  set
}

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
pub fn Regex::to_nfa(regex : Regex, initial~ : Int) -> NFA {
  let { nfa, count } = regex.to_nfac(initial~)
  let nfat = NFAT::new(count)
  fn connect(from : Int, sym : Int, to : Int) {
    nfat.add_transition(from, sym, to)
  }

  let eps = 0
  fn dfs(nfa : RNFA) -> Edge {
    match nfa {
      Choice(initial~, top, bot, final_~) => {
        let edge_top = dfs(top)
        let edge_bot = dfs(bot)
        connect(initial, eps, edge_top.initial)
        connect(initial, eps, edge_bot.initial)
        connect(edge_top.final_, eps, final_)
        connect(edge_bot.final_, eps, final_)
        Edge::{ initial, final_ }
      }
      Concat(left, right) => {
        let { initial, final_: from } = dfs(left)
        let { initial: to, final_ } = dfs(right)
        connect(from, eps, to)
        Edge::{ initial, final_ }
      }
      Symbol(initial~, sym, final_~) => {
        connect(initial, sym, final_)
        Edge::{ initial, final_ }
      }
      Repeat(initial~, nfa, final_~) => {
        let edge_nfa = dfs(nfa)
        connect(initial, eps, edge_nfa.initial)
        connect(edge_nfa.final_, eps, edge_nfa.initial)
        connect(edge_nfa.final_, eps, final_)
        Edge::{ initial, final_ }
      }
    }
  }

  let { initial, final_ } = dfs(nfa)
  { initial, final_, nfat }
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
      None => Some(set_singleton(to))
      Some(set) => Some(set_add(set, to))
    }
  })
}

///|
fn NFAT::trans(self : NFAT, from : Int, sym : Int) -> Set[Int] {
  let edges = self.0[from]
  match self.0.get(from) {
    Some(_) =>
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
  while pending.pop() is Some(initial) {
    for final_ in nfat.trans(initial, EpsilonSymbol) {
      if !result.contains(final_) {
        result.add(final_)
        pending.push(final_)
      }
    }
  }
  result
}

///|
fn NFAT::move_(nfat : NFAT, initials : Set[Int], sym : Int) -> Set[Int] {
  let result = Set::new()
  for initial in initials {
    for final_ in nfat.trans(initial, sym) {
      result.add(final_)
    }
  }
  result
}

///|
fn RDFAT::add_transition(
  dfat : RDFAT,
  from : NFAS,
  sym : Int,
  to : NFAS,
) -> Unit {
  fn connect(edge : Map[Int, NFAS]) -> Map[Int, NFAS]? {
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

  dfat.update(from, fn(edge) {
    match edge {
      Some(edge) => connect(edge)
      None => connect({})
    }
  })
}

///|
pub fn NFA::powerset_construction(nfa : NFA, alphatbet_count : Int) -> RDFA {
  let nfat = nfa.nfat
  let pending = []
  let dfa_initial : NFAS = nfat.epsilon_closure(set_singleton(nfa.initial))
  let dfa_finals : Set[NFAS] = Set::new()
  let dfat : RDFAT = Map::new()
  pending.push(dfa_initial)
  fn connect(from : NFAS, sym : Int, to : NFAS) {
    dfat.add_transition(from, sym, to)
  }

  while pending.pop() is Some(dfs_state) {
    // epsilon is 0, so start from 1
    for sym in 1..<(alphatbet_count + 1) {
      let new_dfa_state = nfat.epsilon_closure(nfat.move_(dfs_state.0, sym))
      if new_dfa_state.contains(nfa.final_) {
        dfa_finals.add(new_dfa_state)
      }
      connect(dfs_state, sym, new_dfa_state)
      if !dfat.contains(new_dfa_state) {
        pending.push(new_dfa_state)
      }
    }
  }
  RDFA::{ initial: dfa_initial, finals: dfa_finals, dfat }
}

///|
pub fn RDFA::to_digraph(
  self : RDFA,
  symbol_to_letter~ : (Int) -> Char,
) -> @graphviz.Digraph {
  let map : Map[NFAS, Int] = {}
  let mut count = 0
  for dfs_state, _ in self.dfat {
    map[dfs_state] = count
    count += 1
  }
  map[self.initial] = 0
  let nodes = []
  let edges = []
  fn state_to_node(s : NFAS) {
    let id = map[s]
    let label = if id == 0 { "S" } else { id.to_string() }
    @graphviz.Node::{ id, label: Some(label) }
  }

  fn mk_edge(from : NFAS, label : Char, to : NFAS) -> @graphviz.Edge {
    let from = map[from]
    let to = map[to]
    { from, to, label: Some(String::make(1, label)) }
  }

  fn connect(from : NFAS, sym : Int, to : NFAS) {
    edges.push(mk_edge(from, symbol_to_letter(sym), to))
  }

  fn add_fresh_state(s : NFAS) {
    if !s.0.is_empty() {
      nodes.push(state_to_node(s))
    } else {
      nodes.push(@graphviz.Node::{ id: map[s], label: Some("E") })
    }
  }

  for initial, trans in self.dfat {
    add_fresh_state(initial)
    if !initial.0.is_empty() {
      for sym, final_ in trans {
        connect(initial, sym, final_)
      }
    }
  }
  { nodes, edges, rankdir: LeftToRight }
}

///|
pub fn RNFA::to_digraph(
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

  fn add_fresh_state(initial : Int, final_ : Int) {
    nodes.push(int_to_node(initial))
    nodes.push(int_to_node(final_))
  }

  fn dfs(nfa : RNFA) -> Edge {
    match nfa {
      Choice(initial~, top, bot, final_~) => {
        add_fresh_state(initial, final_)
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
        add_fresh_state(initial, final_)
        connect(initial, symbol_to_letter(sym), final_)
        Edge::{ initial, final_ }
      }
      Repeat(initial~, nfa, final_~) => {
        add_fresh_state(initial, final_)
        let edge_nfa = dfs(nfa)
        connect(initial, Epsilon, edge_nfa.initial)
        connect(edge_nfa.final_, Epsilon, edge_nfa.initial)
        connect(edge_nfa.final_, Epsilon, final_)
        Edge::{ initial, final_ }
      }
    }
  }

  let { initial, .. } = dfs(nfa)
  let ipos = edges.search_by(edge => edge.from == initial).unwrap()
  edges.swap(0, ipos)
  @graphviz.Digraph::{ nodes, edges, rankdir: LeftToRight }
}

///|
pub fn DFA::to_digraph(
  self : DFA,
  symbol_to_letter~ : (Int) -> Char,
) -> @graphviz.Digraph {
  let nodes = []
  let edges = []
  fn state_to_node(id : Int) {
    let label = if id == 0 { "S" } else { id.to_string() }
    @graphviz.Node::{ id, label: Some(label) }
  }

  fn mk_edge(from : Int, label : Char, to : Int) -> @graphviz.Edge {
    { from, to, label: Some(String::make(1, label)) }
  }

  fn connect(from : Int, sym : Int, to : Int) {
    // move to 1-based symbols for display
    // 0 is epsilon
    edges.push(mk_edge(from, symbol_to_letter(sym + 1), to))
  }

  fn add_fresh_state(id : Int) {
    if id != self.dead_state() {
      nodes.push(state_to_node(id))
    } else {
      nodes.push(@graphviz.Node::{ id, label: Some("E") })
    }
  }

  for initial, trans in self.edfat {
    add_fresh_state(initial)
    for sym, final_ in trans {
      connect(initial, sym, final_)
    }
  }
  // add dead state
  add_fresh_state(self.dead_state())
  { nodes, edges, rankdir: LeftToRight }
}

///|
pub fn DFA::dead_state(self : DFA) -> Int {
  self.edfat.length()
}

///|
pub fn NFAT::to_digraph(
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
      for final_ in finals {
        connect(initial, sym, final_)
      }
    }
  }
  { nodes, edges, rankdir: LeftToRight }
}

///|
pub fn NFA::to_digraph(
  nfa : NFA,
  symbol_to_letter~ : (Int) -> Char,
) -> @graphviz.Digraph {
  nfa.nfat.to_digraph(symbol_to_letter~)
}

///|
fn RDFA::to_dfa_state_map(dfa : RDFA) -> Map[NFAS, Int] {
  let result : Map[NFAS, Int] = Map::new()
  let mut count = 1
  for dfas in dfa.dfat.keys() {
    if dfas == dfa.initial {
      result[dfas] = 0
    } else if dfas.0.is_empty() {
      result[dfas] = dfa.dfat.length() - 1
    } else {
      result[dfas] = count
      count += 1
    }
  }
  result
}

///|
pub fn RDFA::to_dfa(rdfa : RDFA) -> DFA {
  let state_count = rdfa.dfat.length()
  let alphatbet_count = rdfa.dfat[rdfa.initial].length()
  // exclude the dead state 
  let edfat = FixedArray::makei(state_count - 1, _ => FixedArray::make(
    alphatbet_count, 0,
  ))
  let map = rdfa.to_dfa_state_map()
  for initial, trans in rdfa.dfat {
    // exclude dead state
    if !initial.0.is_empty() {
      for sym, final_ in trans {
        let initial = map[initial]
        let final_ = map[final_]
        // exclude epsilon transitions
        edfat[initial][sym - 1] = final_
      }
    }
  }
  let initial = map[rdfa.initial]
  let finals = rdfa.finals.iter().map(s => map[s]) |> Set::from_iter
  DFA::{ initial, finals, edfat }
}

///|
pub fn DFA::reverse_transition(
  dfa : DFA,
  alphatbet_count : Int,
) -> FixedArray[FixedArray[Set[Int]]] {
  let dead_state = dfa.dead_state()
  // include dead state 
  let result = FixedArray::makei(dead_state + 1, _ => FixedArray::makei(
    alphatbet_count,
    _ => Set::new(),
  ))
  for from, trans in dfa.edfat {
    for sym in 0..<alphatbet_count {
      let to = trans[sym]
      result[to][sym].add(from)
    }
  }
  result
}

///|
pub fn DFA::partition(dfa : DFA, alphatbet_count : Int) -> Set[DFAS] {
  let result : Set[DFAS] = Set::new()
  let all : DFAS = Set::from_iter(Int::until(0, dfa.dead_state()))
  let finals : DFAS = Set::new()
  finals.0.add(dfa.dead_state())
  let non_finals : DFAS = all - finals
  let refiners : Set[DFAS] = Set::new()
  let reverse_trans = dfa.reverse_transition(alphatbet_count)
  if finals.length() < non_finals.length() {
    refiners.add(finals)
  } else {
    refiners.add(non_finals)
  }
  result.add(finals)
  result.add(non_finals)
  fn from_states(sym : Int, to_set : DFAS) -> DFAS {
    let result = Set::new()
    for to in to_set.0 {
      for from in reverse_trans[to][sym] {
        result.add(from)
      }
    }
    result
  }

  fn pop(set : Set[DFAS]) -> DFAS? {
    match set.iter().head() {
      Some(value) => {
        set.remove(value)
        Some(value)
      }
      None => None
    }
  }

  let unrefined = []
  while pop(refiners) is Some(to_set) {
    refiners.remove(to_set)
    for sym in 0..<alphatbet_count {
      let from_set = from_states(sym, to_set)
      while pop(result) is Some(partition) {
        let intersection = from_set & partition
        let difference = partition - from_set
        if !intersection.is_empty() && !difference.is_empty() {
          // refine partition
          result.add(intersection)
          result.add(difference)
          if refiners.contains(partition) {
            // refine existing refiner
            refiners.remove(partition)
            refiners.add(intersection)
            refiners.add(difference)
          } else if intersection.length() < difference.length() {
            // add new refiner
            refiners.add(intersection)
          } else {
            // add new refiner
            refiners.add(difference)
          }
        } else {
          // doesn't refine the partition
          unrefined.push(partition)
        }
      }
      for part in unrefined {
        result.add(part)
      }
      unrefined.clear()
    }
  }
  result
}

///|
pub fn DFA::minimize(dfa : DFA, alphatbet_count : Int) -> DFA {
  let partitions = dfa.partition(alphatbet_count)
  let map : Map[Int, Int] = Map::new()
  let mut count = 0
  for part in partitions {
    if part.0.contains(dfa.dead_state()) {
      for state in part.0 {
        map[state] = partitions.length() - 1
      }
    } else if part.0.contains(dfa.initial) {
      for state in part.0 {
        map[state] = 0
      }
    } else {
      for state in part.0 {
        map[state] = count
      }
      count += 1
    }
  }
  let state_count = partitions.length()
  let edfat = FixedArray::makei(state_count - 1, _ => FixedArray::make(
    alphatbet_count, 0,
  ))
  for part in partitions {
    let rfrom = part.0.iter().head().unwrap()
    let from = map[rfrom]
    for sym in 0..<alphatbet_count {
      let rto = if dfa.dead_state() == rfrom {
        dfa.dead_state()
      } else {
        dfa.edfat[rfrom][sym]
      }
      let to = map[rto]
      if from != partitions.length() - 1 {
        edfat[from][sym] = to
      }
    }
  }
  let initial = map[dfa.initial]
  let finals : Set[Int] = Set::new()
  for final_ in dfa.finals {
    finals.add(map[final_])
  }
  DFA::{ initial, finals, edfat }
}
