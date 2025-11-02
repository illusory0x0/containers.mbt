///|
pub fn DFAD::full_match(dfad : DFAD, input : String) -> Bool {
  let { dfa, symbol_map } = dfad
  let mut state = dfa.initial
  for ch in input {
    // println(ch.to_int())
    match symbol_map.get(ch) {
      None => return false
      Some(sym) => {
        let new_state = dfa.transition.trans(state, sym)
        guard new_state != dfa.dead_state() else { return false }
        state = new_state
      }
    }
  }
  dfa.finals.contains(state)
}
