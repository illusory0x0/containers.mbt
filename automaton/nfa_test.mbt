///|
test "NFA/normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_label('a'))
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_normal.dot")
}

///|
test "NFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(Epsilon)
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_epsilon.dot")
}

///|
test "NFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_label('a'))
  let right : Regex = Symbol(letter_to_label('b'))
  let regex = Regex::Concat(left, right)
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_concat.dot")
}

///|
test "NFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_label('a'))
  let right : Regex = Symbol(letter_to_label('b'))
  let regex = Regex::Choice(left, right)
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_choice.dot")
}

///|
test "NFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_label('a'))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_repeat.dot")
}

///|
test "NFA/complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_label('a'))
  let b : Regex = Symbol(letter_to_label('b'))
  let c : Regex = Symbol(letter_to_label('c'))
  let ab : Regex = Concat(a, b)
  let ab_choice : Regex = Choice(ab, c)
  let regex : Regex = Repeat(ab_choice)
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_complex.dot")
}
