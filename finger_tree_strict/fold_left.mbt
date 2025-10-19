///|
fn[A, B] Node::fold_left(self : Node[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    Node2(a, b) => f(f(acc, a), b)
    Node3(a, b, c) => f(f(f(acc, a), b), c)
  }
}

///|
fn[A, B] Digit::fold_left(self : Digit[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    One(a) => f(acc, a)
    Two(a, b) => f(f(acc, a), b)
    Three(a, b, c) => f(f(f(acc, a), b), c)
    Four(a, b, c, d) => f(f(f(f(acc, a), b), c), d)
  }
}

///|
fn[A, B] Tree::fold_left(self : Tree[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    Deep(d) => Digit::fold_left(d, acc, f)
    DeepNode(dn) => {
      fn fold_tree(acc, x) {
        Tree::fold_left(x, acc, f)
      }

      fn fold_node(acc, x) {
        Node::fold_left(x, acc, fold_tree)
      }

      Digit::fold_left(dn, acc, fold_node)
    }
    Single(a) => f(acc, a)
    SingleNode(n) =>
      Node::fold_left(n, acc, (acc, x) => Tree::fold_left(x, acc, f))
  }
}

///|
pub fn[A, B] FingerTree::fold_left(
  self : FingerTree[A],
  acc : B,
  f : (B, A) -> B,
) -> B {
  match self {
    Empty => acc
    Single(t) => Tree::fold_left(t, acc, f)
    Deep(pr, m, sf) => {
      let acc1 = Tree::fold_left(pr, acc, f)
      let acc2 = FingerTree::fold_left(m, acc1, f)
      Tree::fold_left(sf, acc2, f)
    }
  }
}
