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
fnalias Lazy::(new as spine, from_val as spine_val)

///|
typealias @lazy.Lazy

///|
typealias Lazy[FingerTree[A]] as Spine[A]

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
