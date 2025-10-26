///|
fn letter_to_symbol(letter : Char) -> Int {
  match letter {
    'ε' => 0
    'a'..='z' => letter.to_int() - 'a'.to_int() + 1
    _ => abort("invalid range")
  }
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
fn nfa_to_digraph(nfa : NFA) -> @graphviz.Digraph {
  nfa.to_digraph(symbol_to_letter~)
}

///|
fn nfat_to_digraph(nfat : NFAT) -> @graphviz.Digraph {
  nfat.to_digraph(symbol_to_letter~)
}

///|
fn dfa_to_digraph(dfa : DFA) -> @graphviz.Digraph {
  dfa.to_digraph(symbol_to_letter~)
}

///|
test "NFA/normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let (nfa, size) = Regex::to_nfa_with_size(regex)
  let digraph = nfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_normal.dot")
}

///|
test "NFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let (nfa, size) = Regex::to_nfa_with_size(regex)
  let digraph = nfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_epsilon.dot")
}

///|
test "NFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let (nfa, size) = regex.to_nfa_with_size()
  let digraph = nfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_concat.dot")
}

///|
test "NFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let (nfa, size) = regex.to_nfa_with_size()
  let digraph = nfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_choice.dot")
}

///|
test "NFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let (nfa, size) = Regex::to_nfa_with_size(regex)
  let digraph = nfa_to_digraph(nfa)
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
  let digraph = nfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_complex.dot")
}

///|
test "NFA Transition/normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let nfa_trans = regex.to_transition()
  let digraph = nfat_to_digraph(nfa_trans)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_symbol_normal.dot")
}

///|
test "NFA Transition/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let nfa_trans = regex.to_transition()
  let digraph = nfat_to_digraph(nfa_trans)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_symbol_epsilon.dot")
}

///|
test "NFA Transition/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let nfa_trans = regex.to_transition()
  let digraph = nfat_to_digraph(nfa_trans)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_concat.dot")
}

///|
test "NFA Transition/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let nfa_trans = regex.to_transition()
  let digraph = nfat_to_digraph(nfa_trans)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_choice.dot")
}

///|
test "NFA Transition/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let nfa_trans = regex.to_transition()
  let digraph = nfat_to_digraph(nfa_trans)
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
  let digraph = nfat_to_digraph(nfa_trans)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_complex.dot")
}

///|
test "DFA/Normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  // let (nfa, size) = Regex::to_nfa_with_size(regex)
  let nfat = regex.to_transition()
  let dfa = nfat.powerset_construction(1 + 2)
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_symbol_normal.dot")
}

///|
test "DFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  // let (nfa, size) = Regex::to_nfa_with_size(regex)
  let nfat = regex.to_transition()
  let dfa = nfat.powerset_construction(1 + 2)
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_symbol_epsilon.dot")
}

///|
test "DFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let nfat = regex.to_transition()
  let dfa = nfat.powerset_construction(1 + 2)
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_concat.dot")
}

///|
test "DFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let nfat = regex.to_transition()
  let dfa = nfat.powerset_construction(1 + 2)
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_choice.dot")
}

///|
test "DFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let nfat = regex.to_transition()
  let dfa = nfat.powerset_construction(1 + 2)
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_repeat.dot")
}

///|
test "DFA/complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_symbol('a'))
  let b : Regex = Symbol(letter_to_symbol('b'))
  let c : Regex = Symbol(letter_to_symbol('c'))
  let ab : Regex = Concat(a, b)
  let ab_choice : Regex = Choice(ab, c)
  let regex : Regex = Repeat(ab_choice)
  let nfat = regex.to_transition()
  let dfa = nfat.powerset_construction(1 + 3)
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_complex.dot")
}
