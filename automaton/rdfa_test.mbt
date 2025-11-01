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
