///|
pub(all) enum Regex {
  Concat(Regex, Regex)
  Choice(Regex, Regex)
  Repeat(Regex)
  Symbol(Symbol)
} derive(Eq, Show, Compare, ToJson)

///|
pub(all) enum RNFA {
  Symbol(initial~ : Int, Symbol, final_~ : Int)
  Concat(RNFA, RNFA)
  Choice(initial~ : Int, RNFA, RNFA, final_~ : Int)
  Repeat(initial~ : Int, RNFA, final_~ : Int)
} derive(Eq, Show, Compare, ToJson)

///|
pub(all) struct NFA {
  initial : Int
  final_ : Int
  alphabet_count : Int
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
struct NFAS(Set[Int]) derive(Eq, ToJson, Show)

///|
struct DFAS(Set[Int]) derive(Eq, Show)

///|
struct RDFAT(Map[NFAS, Map[Int, NFAS]]) derive(Eq, Show, ToJson)

///|
pub struct RDFA {
  initial : NFAS
  finals : Set[NFAS]
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
