///|
pub fn DFA::dead_state(self : DFA) -> DFAS {
  self.transition.length()
}

///|
pub fn DFA::alphabet(dfa : DFA) -> Iter[Symbol] {
  Int::until(0, dfa.alphabet_count).map(Symbol(_))
}

///|
pub fn DFA::reverse_transition(dfa : DFA) -> FixedArray[FixedArray[DFASS]] {
  let dead_state = dfa.dead_state()
  // reverse_transition must include dead state 
  let result = FixedArray::makei(dead_state.to_int() + 1, _ => FixedArray::makei(
    dfa.alphabet_count,
    _ => DFASS::empty(),
  ))
  for from, trans in dfa.transition {
    for sym in dfa.alphabet() {
      let to = trans[sym.to_int()]
      result[to.to_int()][sym.to_int()].add(from)
    }
  }
  result
}

///|
/// Partition the equivalent DFA states into sets of DFASS.
/// the DFA which must contain a dead state, otherwise would panic.
pub fn DFA::partition(dfa : DFA) -> Set[DFASS] {
  let result : Set[DFASS] = Set::new()
  let all : DFASS = Set::new()
  for s in 0..=dfa.dead_state().to_int() {
    all.add(DFAS(s))
  }
  let finals : DFASS = dfa.finals
  let non_finals : DFASS = all - finals
  let refiners : Set[DFASS] = Set::new()
  let reverse_trans = dfa.reverse_transition()
  if finals.length() < non_finals.length() {
    refiners.add(finals)
  } else {
    refiners.add(non_finals)
  }
  result.add(finals)
  result.add(non_finals)
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
    for sym in 0..<dfa.alphabet_count {
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
pub fn DFA::minimize_map(dfa : DFA, partitions : Set[DFASS]) -> Map[DFAS, DFAS] {
  let result : Map[DFAS, DFAS] = Map::new()
  let initial = 0
  let mut count = 1
  let dead = partitions.length() - 1
  for part in partitions {
    if part.contains(dfa.dead_state()) {
      for state in part {
        result[state] = dead
      }
    } else if part.contains(dfa.initial) {
      for state in part {
        result[state] = initial
      }
    } else {
      for state in part {
        result[state] = count
      }
      count += 1
    }
  }
  result
}

///|
/// Minimize the DFA which must contain a dead state, otherwise would panic.
pub fn DFA::minimize(dfa : DFA) -> DFA {
  let partitions = dfa.partition()
  let map = dfa.minimize_map(partitions)
  let state_count = partitions.length()
  let transition : DFAT = FixedArray::makei(state_count - 1, _ => FixedArray::make(
    dfa.alphabet_count,
    DFAS(0),
  ))
  for part in partitions {
    let prev_from = part.iter().head().unwrap()
    let from = map[prev_from]
    for sym in dfa.alphabet() {
      let prev_to = if dfa.dead_state() == prev_from.to_int() {
        dfa.dead_state()
      } else {
        dfa.transition.trans(prev_from, sym)
      }
      let to = map[prev_to]
      if from != partitions.length() - 1 {
        transition.set_trans(from, sym, to)
      }
    }
  }
  let initial = map[dfa.initial]
  let finals : DFASS = Set::new()
  for final_ in dfa.finals {
    finals.add(map[final_])
  }
  DFA::{ initial, finals, transition, alphabet_count: dfa.alphabet_count }
}
