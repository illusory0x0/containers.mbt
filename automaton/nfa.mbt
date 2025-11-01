///|
pub fn NFA::alphabet(nfa : NFA) -> Iter[Symbol] {
  Int::until(0, nfa.alphabet_count).map(Symbol(_))
}

///|
pub fn NFA::epsilon_closure(nfa : NFA, initials : NFASS) -> NFASS {
  nfa.transition.epsilon_closure(initials)
}

///|
pub fn NFA::move_(nfa : NFA, initials : NFASS, sym : Symbol) -> NFASS {
  nfa.transition.move_(initials, sym)
}

///|
pub fn NFA::powerset_construction(nfa : NFA) -> RDFA {
  let initial : NFASS = nfa.epsilon_closure(NFASS::singleton(nfa.initial))
  let finals : Set[NFASS] = Set::new()
  let transition : RDFAT = RDFAT::new()
  let pending = [initial]
  fn connect(from : NFASS, sym : Symbol, to : NFASS) {
    transition.add_transition(from, sym, to)
  }

  while pending.pop() is Some(dfs_state) {
    for sym in nfa.alphabet() {
      let new_dfa_state = nfa.epsilon_closure(nfa.move_(dfs_state, sym))
      connect(dfs_state, sym, new_dfa_state)
      if new_dfa_state.contains(nfa.final_) {
        finals.add(new_dfa_state)
      }
      if !transition.contains(new_dfa_state) {
        pending.push(new_dfa_state)
      }
    }
  }
  RDFA::{ initial, finals, transition, alphabet_count: nfa.alphabet_count }
}
