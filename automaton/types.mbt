///|
pub(all) enum Regex {
  Concat(Regex, Regex)
  Choice(Regex, Regex)
  Repeat(Regex)
  Symbol(Int)
} derive(Eq, Show, Compare, ToJson)

///|
pub(all) enum RNFA {
  Symbol(initial~ : Int, Int, final~ : Int)
  Concat(RNFA, RNFA)
  Choice(initial~ : Int, RNFA, RNFA, final~ : Int)
  Repeat(initial~ : Int, RNFA, final~ : Int)
} derive(Eq, Show, Compare, ToJson)

///|
pub(all) struct NFA {
  initial : Int
  final : Int
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

struct DFAT (Map[DFAS, Map[Int, DFAS]]) derive(Eq, Show, ToJson)

///|
pub struct DFA {
  initial : DFAS
  dfat : DFAT
} derive(ToJson, Show)

///|
priv struct Edge {
  initial : Int
  final : Int
}

///|
pub struct NFAC {
  nfa : RNFA
  count : Int
}
