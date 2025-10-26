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
fn rdfa_to_digraph(rdfa : RDFA) -> @graphviz.Digraph {
  rdfa.to_digraph(symbol_to_letter~)
}

///|
fn regex_to_nfa(regex : Regex) -> NFA {
  regex.to_nfa(initial=ToplevelInitialState)
}

///|
fn regex_to_nfat(regex : Regex) -> NFAT {
  regex.to_nfa(initial=ToplevelInitialState).nfat
}

///|
fn rnfa_to_digraph(nfa : RNFA) -> @graphviz.Digraph {
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
fn regex_to_rnfa(regex : Regex) -> RNFA {
  regex.to_nfac(initial=ToplevelInitialState).nfa
}

///|
test "NFA/normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_normal.dot")
}

///|
test "NFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_symbol_epsilon.dot")
}

///|
test "NFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_concat.dot")
}

///|
test "NFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_choice.dot")
}

///|
test "NFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
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
  let nfa = regex_to_rnfa(regex)
  let digraph = rnfa_to_digraph(nfa)
  t.writeln(digraph)
  t.snapshot(filename="nfa_complex.dot")
}

///|
test "NFA Transition/normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let nfat = regex_to_nfat(regex)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_symbol_normal.dot")
}

///|
test "NFA Transition/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let nfat = regex_to_nfat(regex)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_symbol_epsilon.dot")
}

///|
test "NFA Transition/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let nfat = regex_to_nfat(regex)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_concat.dot")
}

///|
test "NFA Transition/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let nfat = regex_to_nfat(regex)
  let digraph = nfat_to_digraph(nfat)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_choice.dot")
}

///|
test "NFA Transition/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let nfat = regex_to_nfat(regex)
  let digraph = nfat_to_digraph(nfat)
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
  let nfa_trans = regex_to_nfat(regex)
  let digraph = nfat_to_digraph(nfa_trans)
  t.writeln(digraph)
  t.snapshot(filename="nfa_trans_complex.dot")
}

///|
test "RDFA/Normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_symbol_normal.dot")
}

///|
test "RDFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_symbol_epsilon.dot")
}

///|
test "RDFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_concat.dot")
}

///|
test "RDFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_choice.dot")
}

///|
test "RDFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_repeat.dot")
}

///|
test "RDFA/complex" (t : @test.T) {
  let a : Regex = Symbol(letter_to_symbol('a'))
  let b : Regex = Symbol(letter_to_symbol('b'))
  let c : Regex = Symbol(letter_to_symbol('c'))
  let ab : Regex = Concat(a, b)
  let ab_choice : Regex = Choice(ab, c)
  let regex : Regex = Repeat(ab_choice)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(3)
  let digraph = rdfa_to_digraph(rdfa)
  t.writeln(digraph)
  t.snapshot(filename="rdfa_complex.dot")
}

///|
test "DFA/Normal symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol('a'))
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_symbol_normal.dot")
}

///|
test "DFA/epsilon symbol" (t : @test.T) {
  let regex : Regex = Symbol(letter_to_symbol(Epsilon))
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_symbol_epsilon.dot")
}

///|
test "DFA/concat" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Concat(left, right)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_concat.dot")
}

///|
test "DFA/choice" (t : @test.T) {
  let left : Regex = Symbol(letter_to_symbol('a'))
  let right : Regex = Symbol(letter_to_symbol('b'))
  let regex = Regex::Choice(left, right)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_choice.dot")
}

///|
test "DFA/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let dfa = rdfa.to_dfa()
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
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(3)
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_complex.dot")
}

///|
test "DFA/minimize/repeat" (t : @test.T) {
  let sym : Regex = Symbol(letter_to_symbol('a'))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(2)
  let dfa = rdfa.to_dfa()
  let p = dfa.partition(2)
  inspect(p, content="{DFAS({2}), DFAS({0, 1})}")
  let min_dfa = dfa.minimize(2)
  let digraph = dfa_to_digraph(min_dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_minimize_repeat.dot")
}

///|
test "DFA/minimize/choice and repeat" (t : @test.T) {
  let sym : Regex = Choice(Symbol(letter_to_symbol('a')),Symbol(letter_to_symbol('b')))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(3)
  let dfa = rdfa.to_dfa()
  let p = dfa.partition(3)
  inspect(p, content="{DFAS({3}), DFAS({0, 1, 2})}")
  let min_dfa = dfa.minimize(3)
  let digraph = dfa_to_digraph(min_dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_minimize_choice_repeat.dot")
}

///|
test "DFA/minimize/choice and repeat/raw" (t : @test.T) {
  let sym : Regex = Choice(Symbol(letter_to_symbol('a')),Symbol(letter_to_symbol('b')))
  let regex : Regex = Repeat(sym)
  let nfa = regex_to_nfa(regex)
  let rdfa = nfa.powerset_construction(3)
  let dfa = rdfa.to_dfa()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_minimize_choice_repeat_raw.dot")
}