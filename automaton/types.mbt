///|
/// regular expression syntax 
pub(all) enum Regex {
  Concat(Regex, Regex)
  Choice(Regex, Regex)
  Repeat(Regex)
  Symbol(Symbol)
} derive(Eq, Show, Compare, ToJson)

///|
/// regular expression NFA syntax
pub(all) enum RNFA {
  Symbol(initial~ : Int, Symbol, final_~ : Int)
  Concat(RNFA, RNFA)
  Choice(initial~ : Int, RNFA, RNFA, final_~ : Int)
  Repeat(initial~ : Int, RNFA, final_~ : Int)
} derive(Eq, Show, Compare, ToJson)

///|
/// non-deterministic finite automaton
pub(all) struct NFA {
  initial : Int
  final_ : Int
  alphabet_count : Int
  nfat : NFAT
} derive(Eq, Show, ToJson)

///|
/// NFA transition table
struct NFAT(FixedArray[Map[Int, Set[Int]]]) derive(Eq, Show, ToJson)

///|
pub const Epsilon = 'ε'

///|
pub const EpsilonSymbol : Int = 0

///|
pub const ToplevelInitialState = 0

///|
/// NFA state set
struct NFASS(Set[Int]) derive(Eq, ToJson, Show)

///|
/// DFA state set
struct DFASS(Set[Int]) derive(Eq, Show)

///|
/// DFA transition table 
/// 
/// DFA state is represented by NFA state sets
struct RDFAT(Map[NFASS, Map[Int, NFASS]]) derive(Eq, Show, ToJson)

///|
/// deterministic finite automaton
/// 
/// DFA state is represented by NFA state sets
pub struct RDFA {
  initial : NFASS
  finals : Set[NFASS]
  dfat : RDFAT
  alphabet_count : Int
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
/// deterministic finite automaton
/// 
/// DFA state is represented by integer indices
pub struct DFA {
  initial : Int
  finals : Set[Int]
  edfat : FixedArray[FixedArray[Int]]
}

///|
struct Symbol(Int) derive(Eq, Show, ToJson, Compare)

///|
pub fn Symbol::from(val : Int) -> Symbol {
  Symbol(val)
}

///|
pub fn Symbol::to_int(self : Symbol) -> Int {
  self.0
}

///|
/// NFA state is represented by integer indices
struct NFAS(Int) derive(Eq, Show, ToJson, Hash)

///|
/// DFA state is represented by integer indices
struct DFAS(Int) derive(Eq, Show, ToJson, Hash)

///|
pub fn NFAS::from(val : Int) -> NFAS {
  NFAS(val)
}

///|
pub fn DFAS::from(val : Int) -> DFAS {
  DFAS(val)
}

///|
pub fn NFAS::to_int(self : NFAS) -> Int {
  self.0
}

///|
pub fn DFAS::to_int(self : DFAS) -> Int {
  self.0
}
