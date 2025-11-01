///|
priv enum Node[A] {
  Node2(A, A)
  Node3(A, A, A)
}

///|
priv enum Digit[A] {
  One(A)
  Two(A, A)
  Three(A, A, A)
  Four(A, A, A, A)
}

///|
priv enum Tree[A] {
  Single(A)
  SingleNode(Node[Tree[A]])
  Deep(Digit[A])
  DeepNode(Digit[Node[Tree[A]]])
}

///|
fn[A] spine(f : () -> FingerTree[A]) -> Lazy[FingerTree[A]] {
  Lazy::new(f)
}

///|
fn[A] spine_val(ft : FingerTree[A]) -> Lazy[FingerTree[A]] {
  Lazy::from_val(ft)
}

///|
using @lazy {type Lazy}

///|
type Spine[A] = Lazy[FingerTree[A]]

///|
enum FingerTree[A] {
  Empty
  Single(Tree[A])
  Deep(Tree[A], Spine[A], Tree[A])
}

///|
pub fn[A] FingerTree::empty() -> FingerTree[A] {
  FingerTree::Empty
}

///|
pub enum ViewLeft[A] {
  Nil
  Cons(A, Spine[A])
}

///|
pub enum ViewRight[A] {
  Nil
  Snoc(Spine[A], A)
}
