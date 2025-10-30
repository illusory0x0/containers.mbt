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
  Symbol(initial~ : NFAS, Symbol, final_~ : NFAS)
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
  nfat : NFAT
} derive(Eq, Show, ToJson)

///|
/// NFA transition table
struct NFAT(FixedArray[Map[Symbol, NFASS]]) derive(Eq, Show, ToJson)

///|
pub const Epsilon = 'ε'

///|
pub const EpsilonSymbol : Int = 0

///|
pub const ToplevelInitialState = 0

///|
/// NFA state set
struct NFASS(Set[NFAS]) derive(Eq, ToJson, Show)

///|
/// DFA state set
struct DFASS(Set[DFAS]) derive(Eq, Show)

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
  dfat : RDFAT
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
  edfat : DFAT
}

///|
struct DFAT(FixedArray[FixedArray[DFAS]]) derive(Eq, Show, ToJson)

///|
struct Symbol(Int) derive(Eq, Show, ToJson, Compare, Hash)

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
struct NFAS(Int) derive(Eq, Show, ToJson, Hash, Compare)

///|
/// DFA state is represented by integer indices
struct DFAS(Int) derive(Eq, Show, ToJson, Hash)
