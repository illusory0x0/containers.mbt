///|
pub fn RDFA::states(rdfa : RDFA) -> Iter[NFASS] {
  rdfa.transition.states()
}

///|
pub fn RDFA::count(rdfa : RDFA) -> Int {
  rdfa.transition.length()
}

///|
/// - DFA initial state: 0
/// - DFA dead state: state_count - 1
/// - DFA other states: { s in N, 0 < s < state_count - 1 }
fn RDFA::nfass_to_dfas_map(rdfa : RDFA) -> Map[NFASS, DFAS] {
  let result : Map[NFASS, DFAS] = Map::new()
  let initial = 0
  let mut count = 1
  let dead = rdfa.count() - 1
  for dfas in rdfa.states() {
    if dfas == rdfa.initial {
      result[dfas] = initial
    } else if dfas.is_empty() {
      result[dfas] = dead
    } else {
      result[dfas] = count
      count += 1
    }
  }
  result
}

///|
pub fn RDFA::to_dfa(rdfa : RDFA) -> DFA {
  let state_count = rdfa.transition.length()
  // construct DFAT exclude the dead state 
  let transition : DFAT = FixedArray::makei(state_count - 1, _ => FixedArray::make(
    rdfa.alphabet_count,
    DFAS(0),
  ))
  let nfass_to_dfas = rdfa.nfass_to_dfas_map()
  for initial, trans in rdfa.transition {
    // exclude dead state
    if !initial.is_empty() {
      for sym, final_ in trans {
        let initial = nfass_to_dfas[initial]
        let final_ = nfass_to_dfas[final_]
        transition.set_trans(initial, sym, final_)
      }
    }
  }
  let initial = nfass_to_dfas[rdfa.initial]
  let finals = rdfa.finals.iter().map(s => nfass_to_dfas[s]) |> Set::from_iter
  DFA::{ initial, finals, transition, alphabet_count: rdfa.alphabet_count }
}
