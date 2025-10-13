# illusory0x0/finger_tree 

## Encoding Finger Tree in MoonBit 

State 1 : basic definition

```mbt skip 
///|
enum FingerTree[A] {
  Empty
  Single(A)
  Deep(Digit[A], FingerTree[Node[A]], Digit[A])
}

///|
enum Node[A] {
  Node2(A, A)
  Node3(A, A, A)
}

///|
enum Digit[A] {
  One(A)
  Two(A, A)
  Three(A, A, A)
  Four(A, A, A, A)
}
```

State 2: substitute `Node[A]` for `A`

```mbt skip 
enum FingerTree[Node[A]] {
  Empty
  Single(Node[A])
  Deep(Digit[Node[A]], FingerTree[Node[Node[A]]], Digit[Node[A]])
}
```

State 3:  combine `State 1` and `State 2`, convert non-schematic form of recursion to schematic form of recursion. 

```mbt skip 
///|
/// for FingerTree::Single(A), A might be `A` or `Node[A]`
///                 ^^^^^^^^   ^^
enum Single[A] {
  Leaf(A)
  Node(Node[Single[A]])
}

///|
/// FingerTree::Deep(Digit[A],_,Digit[A]), Digit[A] might be `Digit[A]` or `Digit[Node`
///                  ^^^^^^^^   ^^^^^^^    ^^^^^^^
enum Deep[A] {
  Leaf(Digit[A])
  Node(Digit[Node[Deep[A]]])
}

///|
/// FingerTree of schematic form of recursion
enum FingerTree[A] {
  Empty
  Single(Single[A])
  Deep(Deep[A], FingerTree[A], Deep[A])
}
```