///|
fn NFA::to_digraph(nfa : NFA) -> @graphviz.Digraph {
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

  fn dfs(nfa : NFA) -> Edge {
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
  nodes.push(@graphviz.Node::{ id: ToplevelInitialState, label: Some("S") })
  connect(ToplevelInitialState, Epsilon, initial)
  edges.swap(0, edges.length() - 1)
  @graphviz.Digraph::{ nodes, edges, rankdir: LeftToRight }
}

///|
test "NFA/normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let (nfa, size) = Regex::to_nfa_with_size(regex)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_normal.dot")
}

///|
test "NFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let (nfa, size) = Regex::to_nfa_with_size(regex)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_epsilon.dot")
}

///|
test "NFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let (nfa, size) = regex.to_nfa_with_size()
  let digraph = nfa.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_concat.dot")
}

///|
test "NFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let (nfa, size) = regex.to_nfa_with_size()
  let digraph = nfa.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_choice.dot")
}

///|
test "NFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let (nfa, size) = Regex::to_nfa_with_size(regex)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_repeat.dot")
}

///|
test "NFA/complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_symbol('a'))
  let b : Regex = Symbol(letter_to_symbol('b'))
  let c : Regex = Symbol(letter_to_symbol('c'))
  let ab : Regex = Concat(a, b)
  let ab_choice : Regex = Choice(ab, c)
  let regex : Regex = Repeat(ab_choice)
  let (nfa, size) = Regex::to_nfa_with_size(regex)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_complex.dot")
}

///|
test "NFA Transition/normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let nfa_trans = regex.to_transition()
  let digraph = nfa_trans.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_symbol_normal.dot")
}

///|
test "NFA Transition/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let nfa_trans = regex.to_transition()
  let digraph = nfa_trans.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_symbol_epsilon.dot")
}

///|
test "NFA Transition/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let nfa_trans = regex.to_transition()
  let digraph = nfa_trans.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_concat.dot")
}

///|
test "NFA Transition/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let nfa_trans = regex.to_transition()
  let digraph = nfa_trans.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_choice.dot")
}

///|
test "NFA Transition/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let nfa_trans = regex.to_transition()
  let digraph = nfa_trans.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_repeat.dot")
}

///|
test "NFA Transition/complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_symbol('a'))
  let b : Regex = Symbol(letter_to_symbol('b'))
  let c : Regex = Symbol(letter_to_symbol('c'))
  let ab : Regex = Concat(a, b)
  let ab_choice : Regex = Choice(ab, c)
  let regex : Regex = Repeat(ab_choice)
  let nfa_trans = regex.to_transition()
  let digraph = nfa_trans.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_complex.dot")
}

///|
test "DFA/Normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  // let (nfa, size) = Regex::to_nfa_with_size(regex)
  let nfat = regex.to_transition()
  let dfa = nfat.powerset_construction(1 + 2)
  let digraph = dfa.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="dfa_symbol_normal.dot")
}
