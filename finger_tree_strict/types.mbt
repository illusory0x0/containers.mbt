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
  //              ^^^^^^^ 
  //              Self 
  Deep(Digit[A])
  DeepNode(Digit[Node[Tree[A]]])
  //                  ^^^^^^^
  //                   Self 
}

///|
enum FingerTree[A] {
  Empty
  Single(Tree[A])
  //     ^^^^^^
  //     type refine to `Single[A]` or  `SingleNode[A]`
  Deep(Tree[A], FingerTree[A], Tree[A])
}

///|
pub fn[A] FingerTree::empty() -> FingerTree[A] {
  FingerTree::Empty
}

///|
pub enum ViewLeft[A] {
  Nil
  Cons(A, FingerTree[A])
}

///|
pub enum ViewRight[A] {
  Nil
  Snoc(FingerTree[A], A)
}
