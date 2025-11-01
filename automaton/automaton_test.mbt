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

///|
test "NFA Transition/normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_label('a'))
  let nfat = regex_to_nfat(regex, alphabet_count=1)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_symbol_normal.dot")
}

///|
test "NFA Transition/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(Epsilon)
  let nfat = regex_to_nfat(regex, alphabet_count=1)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_symbol_epsilon.dot")
}

///|
test "NFA Transition/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_label('a'))
  let right : Regex = Symbol(letter_to_label('b'))
  let regex = Regex::Concat(left, right)
  let nfat = regex_to_nfat(regex, alphabet_count=2)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_concat.dot")
}

///|
test "NFA Transition/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_label('a'))
  let right : Regex = Symbol(letter_to_label('b'))
  let regex = Regex::Choice(left, right)
  let nfat = regex_to_nfat(regex, alphabet_count=2)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_choice.dot")
}

///|
test "NFA Transition/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_label('a'))
  let regex : Regex = Repeat(sym)
  let nfat = regex_to_nfat(regex, alphabet_count=1)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_repeat.dot")
}

///|
test "NFA Transition/complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_label('a'))
  let b : Regex = Symbol(letter_to_label('b'))
  let c : Regex = Symbol(letter_to_label('c'))
  let ab : Regex = Concat(a, b)
  let ab_choice : Regex = Choice(ab, c)
  let regex : Regex = Repeat(ab_choice)
  let nfa_trans = regex_to_nfat(regex, alphabet_count=3)
  let digraph = nfat_to_digraph(nfa_trans)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_complex.dot")
}

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
test "RDFA/complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_label('a'))
  let b : Regex = Symbol(letter_to_label('b'))
  let c : Regex = Symbol(letter_to_label('c'))
  let ab : Regex = Concat(a, b)
  let ab_choice : Regex = Choice(ab, c)
  let regex : Regex = Repeat(ab_choice)
  let nfa = regex_to_nfa(regex, alphabet_count=3)
  let rdfa = nfa.powerset_construction()
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_complex.dot")
}

///|
test "DFA/Normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_label('a'))
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_symbol_normal.dot")
}

///|
test "DFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(Epsilon)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_symbol_epsilon.dot")
}

///|
test "DFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_label('a'))
  let right : Regex = Symbol(letter_to_label('b'))
  let regex = Regex::Concat(left, right)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_concat.dot")
}

///|
test "DFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_label('a'))
  let right : Regex = Symbol(letter_to_label('b'))
  let regex = Regex::Choice(left, right)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_choice.dot")
}

///|
test "DFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_label('a'))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_repeat.dot")
}

///|
test "DFA/complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_label('a'))
  let b : Regex = Symbol(letter_to_label('b'))
  let c : Regex = Symbol(letter_to_label('c'))
  let ab : Regex = Concat(a, b)
  let ab_choice : Regex = Choice(ab, c)
  let regex : Regex = Repeat(ab_choice)
  let nfa = regex_to_nfa(regex, alphabet_count=3)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_complex.dot")
}

///|
test "DFA/minimize/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_label('a'))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let p = dfa.partition(2)
  inspect(p, content="{DFASS({DFAS(2)}), DFASS({DFAS(0), DFAS(1)})}")
  let min_dfa = dfa.minimize(2)
  let digraph = dfa_to_digraph(min_dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_minimize_repeat.dot")
}

///|
test "DFA/minimize/choice and repeat" (t : @test.T) {
  let sym : Regex = Choice(
    Symbol(letter_to_label('a')),
    Symbol(letter_to_label('b')),
  )
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex, alphabet_count=3)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let p = dfa.partition(3)
  inspect(p, content="{DFASS({DFAS(3)}), DFASS({DFAS(0), DFAS(1), DFAS(2)})}")
  let min_dfa = dfa.minimize(3)
  let digraph = dfa_to_digraph(min_dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_minimize_choice_repeat.dot")
}

///|
test "DFA/minimize/choice and repeat/raw" (t : @test.T) {
  let sym : Regex = Choice(
    Symbol(letter_to_label('a')),
    Symbol(letter_to_label('b')),
  )
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex, alphabet_count=3)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_minimize_choice_repeat_raw.dot")
}

///|
test "panic DFA/minimize/all/raw" (t : @test.T) {
  // FIXME: when DFA accept all language, in this cases would panic
  let sym : Regex = Choice(
    Symbol(letter_to_label('a')),
    Symbol(letter_to_label('b')),
  )
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex, alphabet_count=2)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_minimize_choice_repeat_raw.dot")
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
