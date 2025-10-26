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
priv struct Edge {
  initial : Int
  final : Int
}
