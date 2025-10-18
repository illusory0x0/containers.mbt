///|
enum TwoThreeTree[A] {
  Empty
  Two(TwoThreeTree[A], A, TwoThreeTree[A])
  Three(TwoThreeTree[A], A, TwoThreeTree[A], A, TwoThreeTree[A])
} derive(ToJson, Show)

///|
pub fn[A] TwoThreeTree::empty() -> TwoThreeTree[A] {
  Empty
}

///|
pub enum ViewLeft[A] {
  Nil
  Cons(A, TwoThreeTree[A])
}

///|
pub enum ViewRight[A] {
  Lin
  Snoc(TwoThreeTree[A], A)
}
