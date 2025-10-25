///|
fn symbol_to_letter(sym : Int) -> Char {
  match sym {
    0 => Epsilon
    1..=26 => Int::unsafe_to_char('a'.to_int() + sym + 1)
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
  connect(ToplevelInitialState,Epsilon,initial)
  @graphviz.Digraph::{ nodes, edges, rankdir: LeftToRight }
}


test (t : @test.T){
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let (nfa,size) = Regex::to_nfa_with_size(sym)
  let digraph = NFA::to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol.dot")
}