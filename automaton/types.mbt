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
struct NFAS(Set[Int]) derive(Eq, ToJson, Show)

///|
impl Hash for NFAS with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
struct DFAS(@immut/sorted_set.SortedSet[Int]) derive(Eq, Show,Compare)

///|
impl Sub for DFAS with sub(x, y) {
  @immut/sorted_set.SortedSet::difference(x.0,y.0)
}

///|
impl BitAnd for DFAS with land(x, y) {
  @immut/sorted_set.SortedSet::intersection(x.0,y.0)
}

///|
fn DFAS::is_empty(set : DFAS) -> Bool {
  set.0.is_empty()
}

///|
struct DFAT(Map[NFAS, Map[Int, NFAS]]) derive(Eq, Show, ToJson)

///|
pub struct RDFA {
  initial : NFAS
  finals : Set[NFAS]
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
