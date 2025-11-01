///|
pub fn DFA::dead_state(self : DFA) -> DFAS {
  self.edfat.length()
}

///|
pub fn DFA::reverse_transition(
  dfa : DFA,
  alphabet_count : Int,
) -> FixedArray[FixedArray[DFASS]] {
  let dead_state = dfa.dead_state()
  // include dead state 
  let result = FixedArray::makei(dead_state.to_int() + 1, _ => FixedArray::makei(
    alphabet_count,
    _ => DFASS::empty(),
  ))
  for from, trans in dfa.edfat {
    for sym in 0..<alphabet_count {
      let to = trans[sym]
      result[to.to_int()][sym].add(from)
    }
  }
  result
}

///|
/// Partition the equivalent DFA states into sets of DFASS.
/// the DFA which must contain a dead state, otherwise would panic.
pub fn DFA::partition(dfa : DFA, alphabet_count : Int) -> Set[DFASS] {
  let result : Set[DFASS] = Set::new()
  let all : DFASS = Set::new()
  for s in 0..<dfa.dead_state().to_int() {
    all.add(DFAS(s))
  }
  let dead_states : DFASS = set_singleton(DFAS(dfa.dead_state().to_int()))
  let live_states : DFASS = all - dead_states
  let refiners : Set[DFASS] = Set::new()
  let reverse_trans = dfa.reverse_transition(alphabet_count)
  if dead_states.length() < live_states.length() {
    refiners.add(dead_states)
  } else {
    refiners.add(live_states)
  }
  result.add(dead_states)
  result.add(live_states)
  fn from_states(sym : Int, to_set : DFASS) -> DFASS {
    let result = DFASS::empty()
    for to in to_set {
      for from in reverse_trans[to.to_int()][sym] {
        result.add(from)
      }
    }
    result
  }

  fn pop(set : Set[DFASS]) -> DFASS? {
    match set.iter().head() {
      Some(value) => {
        set.remove(value)
        Some(value)
      }
      None => None
    }
  }

  let unrefined = []
  while pop(refiners) is Some(to_set) {
    for sym in 0..<alphabet_count {
      let from_set = from_states(sym, to_set)
      // pop the result, if not refine, then re-add it from unrefined
      while pop(result) is Some(partition) {
        let intersection = from_set & partition
        let difference = partition - from_set
        if !intersection.is_empty() && !difference.is_empty() {
          // refine partition
          result.add(intersection)
          result.add(difference)
          if refiners.contains(partition) {
            // refine existing refiner
            refiners.remove(partition)
            refiners.add(intersection)
            refiners.add(difference)
          } else if intersection.length() < difference.length() {
            // add new refiner
            refiners.add(intersection)
          } else {
            // add new refiner
            refiners.add(difference)
          }
        } else {
          // doesn't refine the partition
          unrefined.push(partition)
        }
      }
      for part in unrefined {
        result.add(part)
      }
      unrefined.clear()
    }
  }
  result
}

///|
/// Minimize the DFA which must contain a dead state, otherwise would panic.
pub fn DFA::minimize(dfa : DFA, alphabet_count : Int) -> DFA {
  let partitions = dfa.partition(alphabet_count)
  let map : Map[DFAS, DFAS] = Map::new()
  let mut count = 0
  for part in partitions {
    if part.contains(dfa.dead_state()) {
      for state in part {
        map[state] = partitions.length() - 1
      }
    } else if part.contains(dfa.initial) {
      for state in part {
        map[state] = 0
      }
    } else {
      for state in part {
        map[state] = count
      }
      count += 1
    }
  }
  let state_count = partitions.length()
  let edfat : DFAT = FixedArray::makei(state_count - 1, _ => FixedArray::make(
    alphabet_count,
    DFAS(0),
  ))
  for part in partitions {
    let prev_from = part.iter().head().unwrap()
    let from = map[prev_from]
    for sym in 0..<alphabet_count {
      let prev_to = if dfa.dead_state() == prev_from.to_int() {
        dfa.dead_state()
      } else {
        dfa.edfat.trans(prev_from, sym)
      }
      let to = map[prev_to]
      if from != partitions.length() - 1 {
        edfat.set_trans(from, sym, to)
      }
    }
  }
  let initial = map[dfa.initial]
  let finals : DFASS = Set::new()
  for final_ in dfa.finals {
    finals.add(map[final_])
  }
  DFA::{ initial, finals, edfat }
}
