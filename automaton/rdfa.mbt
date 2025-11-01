///|
fn RDFA::to_dfa_state_map(dfa : RDFA) -> Map[NFASS, DFAS] {
  let result : Map[NFASS, DFAS] = Map::new()
  let mut count = 1
  for dfas in dfa.transition.keys() {
    if dfas == dfa.initial {
      result[dfas] = 0
    } else if dfas.is_empty() {
      result[dfas] = dfa.transition.length() - 1
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
  let alphabet_count = rdfa.transition[rdfa.initial].length()
  // exclude the dead state 
  let transition : DFAT = FixedArray::makei(state_count - 1, _ => FixedArray::make(
    alphabet_count,
    DFAS(0),
  ))
  let map = rdfa.to_dfa_state_map()
  for initial, trans in rdfa.transition {
    // exclude dead state
    if !initial.is_empty() {
      for sym, final_ in trans {
        let initial = map[initial]
        let final_ = map[final_]
        // exclude epsilon transitions
        guard sym is Symbol(sym)
        transition.set_trans(initial, sym, final_)
      }
    }
  }
  let initial = map[rdfa.initial]
  let finals = rdfa.finals.iter().map(s => map[s]) |> Set::from_iter
  DFA::{ initial, finals, transition }
}
