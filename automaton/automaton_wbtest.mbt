///|
fn symbol_to_letter(sym : Int) -> Char {
  match sym {
    0 => Epsilon
    1..=26 => Int::unsafe_to_char('a'.to_int() + sym - 1)
    _ => abort("invalid range")
  }
}

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
struct Edge {
  initial : Int
  final : Int
}

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

  let {initial,..} = dfs(nfa)
  nodes.push(@graphviz.Node::{ id : ToplevelInitialState, label:Some("S") })

  connect(ToplevelInitialState,Epsilon,initial)
  edges.swap(0,edges.length()-1)
  @graphviz.Digraph::{ nodes, edges, rankdir: LeftToRight }
}


test "normal symbol" (t : @test.T){
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let (nfa,size) = Regex::to_nfa_with_size(regex)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_normal.dot")
}
test "epsilon symbol" (t : @test.T) {
    let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let (nfa,size) = Regex::to_nfa_with_size(regex)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_epsilon.dot")
}

test "concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left,right)
  let (nfa,size) = regex.to_nfa_with_size() 
  let digraph = nfa.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_concat.dot")
}

test "choice" (t : @test.T) {
    let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left,right)
  let (nfa,size) = regex.to_nfa_with_size() 
  let digraph = nfa.to_digraph()
  t.writeln(digraph)
  t.snapshot(filename="nfa_choice.dot")
}

test "repeat" (t : @test.T){
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex  = Repeat(sym)
  let (nfa,size) = Regex::to_nfa_with_size(regex)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_repeat.dot")
}

test "complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_symbol('a'))
  let b : Regex = Symbol(letter_to_symbol('b'))
  let c : Regex = Symbol(letter_to_symbol('c'))
  let ab : Regex = Concat(a,b)
  let ab_choice : Regex = Choice(ab,c)
  let regex : Regex = Repeat(ab_choice)
  let (nfa,size) = Regex::to_nfa_with_size(regex)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_complex.dot")
}