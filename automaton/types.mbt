///|
pub(all) enum Regex {
  Concat(Regex, Regex)
  Choice(Regex, Regex)
  Repeat(Regex)
  Symbol(Int)
} derive(Eq, Show, Compare, ToJson)

///|
pub(all) enum RNFA {
  Symbol(initial~ : Int, Int, final_~ : Int)
  Concat(RNFA, RNFA)
  Choice(initial~ : Int, RNFA, RNFA, final_~ : Int)
  Repeat(initial~ : Int, RNFA, final_~ : Int)
} derive(Eq, Show, Compare, ToJson)

///|
pub(all) struct NFA {
  initial : Int
  final_ : Int
  nfat : NFAT
} derive(Eq, Show, ToJson)

///|
struct NFAT(FixedArray[Map[Int, Set[Int]]]) derive(Eq, Show, ToJson)

///|
pub const Epsilon = 'ε'

///|
pub const EpsilonSymbol : Int = 0

///|
pub const ToplevelInitialState = 0

///|
struct DFAS(Set[Int]) derive(Eq, ToJson, Show)

///|
impl Hash for DFAS with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
struct DFAT(Map[DFAS, Map[Int, DFAS]]) derive(Eq, Show, ToJson)

///|
pub struct RDFA {
  initial : DFAS
  finals : Set[DFAS]
  dfat : DFAT
} derive(ToJson, Show)

///|
priv struct Edge {
  initial : Int
  final_ : Int
}

///|
pub struct NFAC {
  nfa : RNFA
  count : Int
}

///|
pub struct DFA {
  initial : Int
  finals : Set[Int]
  edfat : FixedArray[FixedArray[Int]]
}

///|
fn RDFA::to_dfa_state_map(dfa : RDFA) -> Map[DFAS, Int] {
  let result : Map[DFAS, Int] = Map::new()
  let mut count = 1
  for dfas in dfa.dfat.0.keys() {
    if dfas == dfa.initial {
      result[dfas] = 0
    } else if dfas.0.is_empty() {
      result[dfas] = dfa.dfat.0.length() - 1
    } else {
      result[dfas] = count
      count += 1
    }
  }
  result
}

///|
pub fn RDFA::to_dfa(dfa : RDFA) -> DFA {
  let state_count = dfa.dfat.0.length()
  let alphatbet_count = dfa.dfat.0[dfa.initial].length()
  let edfat = FixedArray::makei(state_count, _ => FixedArray::make(
    alphatbet_count, 0,
  ))
  let map = dfa.to_dfa_state_map()
  for initial, trans in dfa.dfat.0 {
    if !initial.0.is_empty() {
      for sym, final_ in trans {
        let initial = map[initial]
        let final_ = map[final_]
        // exclude epsilon transitions
        edfat[initial][sym - 1] = final_
      }
    }
  }
  let initial = map[dfa.initial]
  let finals = dfa.finals.iter().map(s => map[s]) |> Set::from_iter
  DFA::{ initial, finals, edfat }
}
