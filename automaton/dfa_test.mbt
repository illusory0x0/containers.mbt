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
  @json.inspect(nfa, content={
    "initial": ["NFAS", 0],
    "final_": ["NFAS", 3],
    "alphabet_count": 2,
    "transition": [
      "NFAT",
      [
        { "Epsilon": ["NFASS", [["NFAS", 1], ["NFAS", 3]]] },
        { "Symbol(Symbol(0))": ["NFASS", [["NFAS", 2]]] },
        { "Epsilon": ["NFASS", [["NFAS", 1], ["NFAS", 3]]] },
        {},
      ],
    ],
  })
  let rdfa = nfa.powerset_construction()
  @json.inspect(rdfa, content=({"initial":["NFASS",[["NFAS",0],["NFAS",1],["NFAS",3]]],"finals":[["NFASS",[["NFAS",0],["NFAS",1],["NFAS",3]]],["NFASS",[["NFAS",2],["NFAS",1],["NFAS",3]]]],"transition":["RDFAT",{"NFASS({NFAS(0), NFAS(1), NFAS(3)})":{"Symbol(0)":["NFASS",[["NFAS",2],["NFAS",1],["NFAS",3]]],"Symbol(1)":["NFASS",[]]},"NFASS({})":{"Symbol(0)":["NFASS",[]],"Symbol(1)":["NFASS",[]]},"NFASS({NFAS(2), NFAS(1), NFAS(3)})":{"Symbol(0)":["NFASS",[["NFAS",2],["NFAS",1],["NFAS",3]]],"Symbol(1)":["NFASS",[]]}}],"alphabet_count":2}))
  let dfa = rdfa.to_dfa()
  let p = dfa.partition()
  inspect(p, content="{DFASS({DFAS(0), DFAS(1)}), DFASS({DFAS(2)})}")
  let min_dfa = dfa.minimize()
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
  let p = dfa.partition()
  inspect(
    p,
    content="{DFASS({DFAS(0), DFAS(2), DFAS(1)}), DFASS({DFAS(3)})}",
  )
  let min_dfa = dfa.minimize()
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
  // This is expected behavior
  // RDFA::to_dfa depends on the DFA having a dead state.
  // if the DFA accept the `.*` language it would cause no dead state.
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
test "DFA/state explosion" (t : @test.T) {
  let a : Regex = Symbol(letter_to_label('a'))
  let b : Regex = Symbol(letter_to_label('b'))
  let a_or_b : Regex = Choice(a, b)
  let regex : Regex = Concat(Repeat(a_or_b), Concat(a, Concat(a_or_b, a_or_b)))
  let nfa = regex_to_nfa(regex, alphabet_count=3)
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let dfa = dfa.minimize()
  let digraph = dfa_to_digraph(dfa)
  t.writeln(digraph)
  t.snapshot(filename="dfa_state_explosion.dot")
}
