///|
priv enum TreeViewRight[A] {
  Nil
  Snoc(Spine[A], Tree[A])
}

///|
fn[A] FingerTree::unsnoc_tree(tree : FingerTree[A]) -> TreeViewRight[A] {
  match tree {
    Empty => Nil
    Single(x) => Snoc(spine_val(Empty), x)
    Deep(pr, m, sf) => {
      let (init, last) = Tree::unsnoc_digit(sf)
      Snoc(
        spine(fn() { FingerTree::deep_right_tree(pr, m.force(), init) }),
        last,
      )
    }
  }
}

///|
fn[A] Tree::unsnoc_digit(xs : Tree[A]) -> (Tree[A]?, Tree[A]) {
  match xs {
    Deep(One(a)) => (None, Single(a))
    Deep(Two(a, b)) => (Some(Deep(One(a))), Single(b))
    Deep(Three(a, b, c)) => (Some(Deep(Two(a, b))), Single(c))
    Deep(Four(a, b, c, d)) => (Some(Deep(Three(a, b, c))), Single(d))
    DeepNode(One(a)) => (None, SingleNode(a))
    DeepNode(Two(a, b)) => (Some(DeepNode(One(a))), SingleNode(b))
    DeepNode(Three(a, b, c)) => (Some(DeepNode(Two(a, b))), SingleNode(c))
    DeepNode(Four(a, b, c, d)) =>
      (Some(DeepNode(Three(a, b, c))), SingleNode(d))
    _ => panic()
  }
}

///|
fn[A] FingerTree::deep_right_tree(
  pr : Tree[A],
  m : FingerTree[A],
  sf : Tree[A]?,
) -> FingerTree[A] {
  match sf {
    None =>
      match FingerTree::unsnoc_tree(m) {
        Nil => Tree::digit_to_tree(pr)
        Snoc(m, a) => Deep(pr, m, Tree::node_to_digit(a))
      }
    Some(sf) => Deep(pr, spine_val(m), sf)
  }
}

///|
pub fn[A] FingerTree::unsnoc(xs : FingerTree[A]) -> ViewRight[A] {
  match FingerTree::unsnoc_tree(xs) {
    Nil => Nil
    Snoc(init, Single(a)) => Snoc(init, a)
    _ => panic()
  }
}
