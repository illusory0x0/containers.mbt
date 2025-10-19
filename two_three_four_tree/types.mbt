///|
enum TwoThreeFourTree[A] {
  Empty
  Two(TwoThreeFourTree[A], A, TwoThreeFourTree[A])
  Three(TwoThreeFourTree[A], A, TwoThreeFourTree[A], A, TwoThreeFourTree[A])
  Four(
    TwoThreeFourTree[A],
    A,
    TwoThreeFourTree[A],
    A,
    TwoThreeFourTree[A],
    A,
    TwoThreeFourTree[A]
  )
}

///|
pub fn[A] TwoThreeFourTree::empty() -> TwoThreeFourTree[A] {
  Empty
}
