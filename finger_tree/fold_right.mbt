///|
pub fn[A, B] FingerTree::fold_right(
  self : FingerTree[A],
  acc : B,
  f : (B, A) -> B,
) -> B {
  match self {
    Empty => acc
    Single(t) => Tree::fold_right(t, acc, f)
    Deep(pr, m, sf) => {
      let acc1 = Tree::fold_right(sf, acc, f)
      let acc2 = FingerTree::fold_right(m.force(), acc1, f)
      Tree::fold_right(pr, acc2, f)
    }
  }
}

///|
fn[A, B] Node::fold_right(self : Node[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    Node2(a, b) => f(f(acc, b), a)
    Node3(a, b, c) => f(f(f(acc, c), b), a)
  }
}

///|
fn[A, B] Digit::fold_right(self : Digit[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    One(a) => f(acc, a)
    Two(a, b) => f(f(acc, b), a)
    Three(a, b, c) => f(f(f(acc, c), b), a)
    Four(a, b, c, d) => f(f(f(f(acc, d), c), b), a)
  }
}

///|
fn[A, B] Tree::fold_right(self : Tree[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    Deep(d) => Digit::fold_right(d, acc, f)
    DeepNode(dn) => {
      fn fold_tree(acc, x) {
        Tree::fold_right(x, acc, f)
      }

      fn fold_node(acc, x) {
        Node::fold_right(x, acc, fold_tree)
      }

      Digit::fold_right(dn, acc, fold_node)
    }
    Single(a) => f(acc, a)
    SingleNode(n) =>
      Node::fold_right(n, acc, (acc, x) => Tree::fold_right(x, acc, f))
  }
}
