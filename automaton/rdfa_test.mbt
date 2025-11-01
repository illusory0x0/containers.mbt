///|
test "RDFA/Normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_label('a'))
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_symbol_normal.dot")
}

///|
test "RDFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(Epsilon)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_symbol_epsilon.dot")
}

///|
test "RDFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_label('a'))
  let right : Regex = Symbol(letter_to_label('b'))
  let regex = Regex::Concat(left, right)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_concat.dot")
}

///|
test "RDFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_label('a'))
  let right : Regex = Symbol(letter_to_label('b'))
  let regex = Regex::Choice(left, right)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_choice.dot")
}

///|
test "RDFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_label('a'))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_repeat.dot")
}

///|
test "RDFA/no dead state" (t : @test.T) {
  let sym : Regex = Choice(
    Symbol(letter_to_label('a')),
    Symbol(letter_to_label('b')),
  )
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_no_dead_state.dot")
}
