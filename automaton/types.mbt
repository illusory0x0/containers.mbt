///|
/// regular expression syntax 
pub(all) enum Regex {
  Concat(Regex, Regex)
  Choice(Regex, Regex)
  Repeat(Regex)
  Symbol(Label)
} derive(Eq, Show, Compare, ToJson)

///|
enum URegex {
  Concat(URegex, URegex)
  Choice(URegex, URegex)
  Repeat(URegex)
  Range(start~ : Int, end~ : Int)
} derive(Eq, Show, Compare, ToJson)

///|
/// regular expression NFA syntax
pub(all) enum RNFA {
  Symbol(initial~ : NFAS, Label, final_~ : NFAS)
  Concat(RNFA, RNFA)
  Choice(initial~ : NFAS, RNFA, RNFA, final_~ : NFAS)
  Repeat(initial~ : NFAS, RNFA, final_~ : NFAS)
} derive(Eq, Show, Compare, ToJson)

///|
/// non-deterministic finite automaton
pub(all) struct NFA {
  initial : NFAS
  final_ : NFAS
  alphabet_count : Int
  transition : NFAT
} derive(Eq, Show, ToJson)

///|
/// NFA transition table
struct NFAT(FixedArray[Map[Label, NFASS]]) derive(Eq, Show, ToJson)

///|
pub const EpsilonChar = 'ε'

// ///|
// pub const EpsilonSymbol : Int = 0

///|
pub const ToplevelInitialState = 0

///|
/// NFA state set
struct NFASS(Set[NFAS]) derive(Eq, ToJson, Show)

///|
/// DFA state set
struct DFASS(Set[DFAS]) derive(Eq, Show, ToJson)

///|
/// DFA transition table 
/// 
/// DFA state is represented by NFA state sets
struct RDFAT(Map[NFASS, Map[Symbol, NFASS]]) derive(Eq, Show, ToJson)

///|
/// deterministic finite automaton
/// 
/// DFA state is represented by NFA state sets
pub struct RDFA {
  initial : NFASS
  finals : Set[NFASS]
  transition : RDFAT
  alphabet_count : Int
} derive(ToJson, Show)

///|
priv struct Edge[A] {
  initial : A
  final_ : A
}

///|
pub struct NFAC {
  nfa : RNFA
  count : Int
}

///|
/// deterministic finite automaton
/// 
/// DFA state is represented by integer indices
pub struct DFA {
  initial : DFAS
  finals : DFASS
  transition : DFAT
  alphabet_count : Int
} derive(ToJson, Show)

///|
struct DFAT(FixedArray[FixedArray[DFAS]]) derive(Eq, Show, ToJson)

///|
pub(all) enum Label {
  Symbol(Symbol)
  Epsilon
} derive(Eq, Show, ToJson, Compare, Hash)

///|
struct Symbol(Int) derive(Eq, Show, ToJson, Compare, Hash)

///|
/// NFA state is represented by integer indices
struct NFAS(Int) derive(Eq, Show, ToJson, Hash, Compare)

///|
/// DFA state is represented by integer indices
struct DFAS(Int) derive(Eq, Show, ToJson, Hash)

///|
struct SymbolMap(FixedArray[Int]) derive(Eq, Show, ToJson, Hash)

///|
pub fn SymbolMap::length(self : SymbolMap) -> Int = "%fixedarray.length"

///|
struct DFAD {
  symbol_map : SymbolMap
  dfa : DFA
} derive(Show, ToJson)

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

