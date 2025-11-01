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
