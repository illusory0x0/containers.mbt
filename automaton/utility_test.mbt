///|
fn letter_to_label(letter : Char) -> Label {
  match letter {
    'ε' => Epsilon
    'a'..='z' => Symbol(letter.to_int() - 'a'.to_int())
    _ => abort("invalid range")
  }
}

///|
fn label_to_letter(sym : Label) -> Char {
  match sym {
    Label::Epsilon => EpsilonChar
    Label::Symbol(i) => {
      guard 0 <= i && i <= 25
      Int::unsafe_to_char('a'.to_int() + i)
    }
  }
}

///|
fn rdfa_to_digraph(rdfa : RDFA) -> @graphviz.Digraph {
  rdfa.to_digraph(label_to_letter~)
}

///|
fn regex_to_nfa(regex : Regex, alphabet_count~ : Int) -> NFA {
  regex.to_nfa(initial=ToplevelInitialState, alphabet_count~)
}

///|
fn regex_to_nfat(regex : Regex, alphabet_count~ : Int) -> NFAT {
  regex.to_nfa(initial=ToplevelInitialState, alphabet_count~).nfat
}

///|
fn rnfa_to_digraph(nfa : RNFA) -> @graphviz.Digraph {
  nfa.to_digraph(label_to_letter~)
}

///|
fn nfat_to_digraph(nfat : NFAT) -> @graphviz.Digraph {
  nfat.to_digraph(label_to_letter~)
}

///|
fn dfa_to_digraph(dfa : DFA) -> @graphviz.Digraph {
  dfa.to_digraph(label_to_letter~)
}

///|
fn regex_to_rnfa(regex : Regex) -> RNFA {
  regex.to_nfac(initial=ToplevelInitialState).nfa
}
