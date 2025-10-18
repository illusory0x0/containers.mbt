///|
enum TwoThreeTree[A] {
  Empty
  Two(TwoThreeTree[A], A, TwoThreeTree[A])
  Three(TwoThreeTree[A], A, TwoThreeTree[A], A, TwoThreeTree[A])
} derive(ToJson, Show)

///|
typealias (
  TwoThreeTree[A],
  A,
  TwoThreeTree[A],
  A,
  TwoThreeTree[A],
  A,
  TwoThreeTree[A],
) as Four[A]

///|
pub fn[A] TwoThreeTree::empty() -> TwoThreeTree[A] {
  Empty
}
