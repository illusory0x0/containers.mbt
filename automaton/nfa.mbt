///|
pub fn NFA::powerset_construction(nfa : NFA) -> RDFA {
  let nfat = nfa.nfat
  let pending = []
  let dfa_initial : NFASS = nfat.epsilon_closure(NFASS::singleton(nfa.initial))
  let dfa_finals : Set[NFASS] = Set::new()
  let dfat : RDFAT = Map::new()
  pending.push(dfa_initial)
  fn connect(from : NFASS, sym : Symbol, to : NFASS) {
    dfat.add_transition(from, sym, to)
  }

  while pending.pop() is Some(dfs_state) {
    // epsilon is 0, so start from 1
    for sym in 1..<(nfa.alphabet_count + 1) {
      let new_dfa_state = nfat.epsilon_closure(nfat.move_(dfs_state, sym))
      if new_dfa_state.contains(nfa.final_.0) {
        dfa_finals.add(new_dfa_state)
      }
      connect(dfs_state, sym, new_dfa_state)
      if !dfat.contains(new_dfa_state) {
        pending.push(new_dfa_state)
      }
    }
  }
  RDFA::{
    initial: dfa_initial,
    finals: dfa_finals,
    dfat,
    alphabet_count: nfa.alphabet_count,
  }
}
