///|
priv enum TreeViewLeft[A] {
  Nil
  Cons(Tree[A], FingerTree[A])
}

///|
fn[A] FingerTree::uncons_tree(tree : FingerTree[A]) -> TreeViewLeft[A] {
  match tree {
    Empty => Nil
    Single(x) => Cons(x, Empty)
    Deep(pr, m, sf) => {
      let (hd, tl) = Tree::uncons_digit(pr)
      Cons(hd, FingerTree::deep_left_tree(tl, m, sf))
    }
  }
}

///|
fn[A] Tree::uncons_digit(xs : Tree[A]) -> (Tree[A], Tree[A]?) {
  match xs {
    Deep(One(a)) => (Single(a), None)
    Deep(Two(a, b)) => (Single(a), Some(Deep(One(b))))
    Deep(Three(a, b, c)) => (Single(a), Some(Deep(Two(b, c))))
    Deep(Four(a, b, c, d)) => (Single(a), Some(Deep(Three(b, c, d))))
    DeepNode(One(a)) => (SingleNode(a), None)
    DeepNode(Two(a, b)) => (SingleNode(a), Some(DeepNode(One(b))))
    DeepNode(Three(a, b, c)) => (SingleNode(a), Some(DeepNode(Two(b, c))))
    DeepNode(Four(a, b, c, d)) =>
      (SingleNode(a), Some(DeepNode(Three(b, c, d))))
    _ => panic()
  }
}

///|
fn[A] Tree::digit_to_tree(digit : Tree[A]) -> FingerTree[A] {
  match digit {
    Deep(One(a)) => FingerTree::cons(a, Empty)
    Deep(Two(a, b)) => FingerTree::cons(a, FingerTree::cons(b, Empty))
    Deep(Three(a, b, c)) =>
      FingerTree::cons(a, FingerTree::cons(b, FingerTree::cons(c, Empty)))
    Deep(Four(a, b, c, d)) =>
      FingerTree::cons(
        a,
        FingerTree::cons(b, FingerTree::cons(c, FingerTree::cons(d, Empty))),
      )
    DeepNode(One(a)) => FingerTree::cons_tree(SingleNode(a), Empty)
    DeepNode(Two(a, b)) =>
      FingerTree::cons_tree(
        SingleNode(a),
        FingerTree::cons_tree(SingleNode(b), Empty),
      )
    DeepNode(Three(a, b, c)) =>
      FingerTree::cons_tree(
        SingleNode(a),
        FingerTree::cons_tree(
          SingleNode(b),
          FingerTree::cons_tree(SingleNode(c), Empty),
        ),
      )
    DeepNode(Four(a, b, c, d)) =>
      FingerTree::cons_tree(
        SingleNode(a),
        FingerTree::cons_tree(
          SingleNode(b),
          FingerTree::cons_tree(
            SingleNode(c),
            FingerTree::cons_tree(SingleNode(d), Empty),
          ),
        ),
      )
    _ => panic()
  }
}

///|
fn[A] Tree::node_to_digit(node : Tree[A]) -> Tree[A] {
  match node {
    SingleNode(Node2(Single(a), Single(b))) => Deep(Two(a, b))
    SingleNode(Node3(Single(a), Single(b), Single(c))) => Deep(Three(a, b, c))
    SingleNode(Node2(SingleNode(a), SingleNode(b))) => DeepNode(Two(a, b))
    SingleNode(Node3(SingleNode(a), SingleNode(b), SingleNode(c))) =>
      DeepNode(Three(a, b, c))
    _ => panic()
  }
}

///|
fn[A] FingerTree::deep_left_tree(
  pr : Tree[A]?,
  m : FingerTree[A],
  sf : Tree[A],
) -> FingerTree[A] {
  match pr {
    None =>
      match FingerTree::uncons_tree(m) {
        Nil => Tree::digit_to_tree(sf)
        Cons(a, m) => Deep(Tree::node_to_digit(a), m, sf)
      }
    Some(pr) => Deep(pr, m, sf)
  }
}

///|
pub fn[A] FingerTree::uncons(xs : FingerTree[A]) -> ViewLeft[A] {
  match FingerTree::uncons_tree(xs) {
    Nil => Nil
    Cons(Single(a), rest) => Cons(a, rest)
    _ => panic()
  }
}
