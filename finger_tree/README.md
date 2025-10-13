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
```