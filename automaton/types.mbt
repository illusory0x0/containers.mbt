///|
enum Regex {
  Concat(Regex, Regex)
  Choice(Regex, Regex)
  Repeat(Regex)
  Symbol(Int)
} derive(Eq, Show, Compare, ToJson)

///|
enum NFA {
  Symbol(initial~ : Int, Int, final~ : Int)
  Concat(NFA, NFA)
  Choice(initial~ : Int, NFA, NFA, final~ : Int)
  Repeat(initial~ : Int, NFA, final~ : Int)
} derive(Eq, Show, Compare, ToJson)

///|
struct NFAT(FixedArray[Map[Int, Set[Int]]]) derive(Eq, Show, ToJson)

///|
const Epsilon = 'ε'

///|
const ToplevelInitialState = 0

///|
struct DFAState(Set[Int]) derive(Eq, ToJson, Show)

///|
impl Hash for DFAState with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
struct DFA {
  initial : DFAState
  transition : Map[DFAState, Map[Int, DFAState]]
} derive(ToJson, Show)

///|
priv struct Edge {
  initial : Int
  final : Int
}
