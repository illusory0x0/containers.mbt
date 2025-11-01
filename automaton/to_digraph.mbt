///|
pub fn RNFA::to_digraph(
  nfa : RNFA,
  label_to_letter~ : (Label) -> Char,
) -> @graphviz.Digraph {
  let nodes : Array[@graphviz.Node] = []
  let edges : Array[@graphviz.Edge] = []
  fn int_to_node(id : Int) {
    @graphviz.Node::{ id, label: Some(id.to_string()) }
  }

  fn mk_edge(from : NFAS, label : Char, to : NFAS) -> @graphviz.Edge {
    {
      from: from.to_int(),
      to: to.to_int(),
      label: Some(String::make(1, label)),
    }
  }

  fn connect(from : NFAS, label : Char, to : NFAS) {
    edges.push(mk_edge(from, label, to))
  }

  fn add_fresh_state(initial : NFAS, final_ : NFAS) {
    nodes.push(int_to_node(initial.to_int()))
    nodes.push(int_to_node(final_.to_int()))
  }

  fn dfs(nfa : RNFA) -> Edge[NFAS] {
    match nfa {
      Choice(initial~, top, bot, final_~) => {
        add_fresh_state(initial, final_)
        let edge_top = dfs(top)
        let edge_bot = dfs(bot)
        connect(initial, EpsilonChar, edge_top.initial)
        connect(initial, EpsilonChar, edge_bot.initial)
        connect(edge_top.final_, EpsilonChar, final_)
        connect(edge_bot.final_, EpsilonChar, final_)
        Edge::{ initial, final_ }
      }
      Concat(left, right) => {
        let { initial, final_: from } = dfs(left)
        let { initial: to, final_ } = dfs(right)
        connect(from, EpsilonChar, to)
        Edge::{ initial, final_ }
      }
      Symbol(initial~, sym, final_~) => {
        add_fresh_state(initial, final_)
        connect(initial, label_to_letter(sym), final_)
        Edge::{ initial, final_ }
      }
      Repeat(initial~, nfa, final_~) => {
        add_fresh_state(initial, final_)
        let edge_nfa = dfs(nfa)
        connect(initial, EpsilonChar, edge_nfa.initial)
        connect(edge_nfa.final_, EpsilonChar, edge_nfa.initial)
        connect(edge_nfa.final_, EpsilonChar, final_)
        Edge::{ initial, final_ }
      }
    }
  }

  let { initial, .. } = dfs(nfa)
  let ipos = edges.search_by(edge => edge.from == initial.to_int()).unwrap()
  edges.swap(0, ipos)
  @graphviz.Digraph::{ nodes, edges, rankdir: LeftToRight }
}

///|
pub fn RDFA::to_digraph(
  self : RDFA,
  label_to_letter~ : (Label) -> Char,
) -> @graphviz.Digraph {
  let map : Map[NFASS, Int] = {}
  let mut count = 0
  for dfs_state, _ in self.dfat {
    map[dfs_state] = count
    count += 1
  }
  map[self.initial] = 0
  let nodes = []
  let edges = []
  fn state_to_node(s : NFASS) {
    let id = map[s]
    let label = if id == 0 { "S" } else { id.to_string() }
    @graphviz.Node::{ id, label: Some(label) }
  }

  fn mk_edge(from : NFASS, label : Char, to : NFASS) -> @graphviz.Edge {
    let from = map[from]
    let to = map[to]
    { from, to, label: Some(String::make(1, label)) }
  }

  fn connect(from : NFASS, sym : Symbol, to : NFASS) {
    edges.push(mk_edge(from, label_to_letter(Symbol(sym.0)), to))
  }

  fn add_fresh_state(s : NFASS) {
    if !s.is_empty() {
      nodes.push(state_to_node(s))
    } else {
      nodes.push(@graphviz.Node::{ id: map[s], label: Some("E") })
    }
  }

  for initial, trans in self.dfat {
    add_fresh_state(initial)
    if !initial.is_empty() {
      for sym, final_ in trans {
        connect(initial, sym, final_)
      }
    }
  }
  { nodes, edges, rankdir: LeftToRight }
}

///|
pub fn DFA::to_digraph(
  self : DFA,
  label_to_letter~ : (Label) -> Char,
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

  fn connect(from : DFAS, sym : Int, to : DFAS) {
    edges.push(
      mk_edge(from.to_int(), label_to_letter(Symbol(sym)), to.to_int()),
    )
  }

  fn add_fresh_state(id : DFAS) {
    if id != self.dead_state() {
      nodes.push(state_to_node(id.to_int()))
    } else {
      nodes.push(@graphviz.Node::{ id: id.to_int(), label: Some("E") })
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
pub fn NFAT::to_digraph(
  self : NFAT,
  label_to_letter~ : (Label) -> Char,
) -> @graphviz.Digraph {
  let nodes = []
  let edges = []
  fn int_to_node(id : Int) {
    @graphviz.Node::{ id, label: Some(id.to_string()) }
  }

  fn mk_edge(from : Int, label : Char, to : Int) -> @graphviz.Edge {
    { from, to, label: Some(String::make(1, label)) }
  }

  fn connect(from : NFAS, sym : Label, to : NFAS) {
    edges.push(mk_edge(from.to_int(), label_to_letter(sym), to.to_int()))
  }

  fn add_fresh_state(s : NFAS) {
    nodes.push(int_to_node(s.to_int()))
  }

  for initial, trans in self {
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
  label_to_letter~ : (Label) -> Char,
) -> @graphviz.Digraph {
  nfa.nfat.to_digraph(label_to_letter~)
}
