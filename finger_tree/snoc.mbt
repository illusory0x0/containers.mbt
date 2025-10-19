///|
fn[A] Digit::snoc(digit : Digit[A], a : A) -> Digit[A] {
  match digit {
    One(b) => Digit::Two(b, a)
    Two(c, b) => Digit::Three(c, b, a)
    Three(d, c, b) => Digit::Four(d, c, b, a)
    Four(_, _, _, _) => abort("cannot snoc to a Four")
  }
}

///|
/// - `param`: `finger_tree`
/// - `param`: `tree` refine to `Single[A]` or `SingleNode[A]`
/// - `return`: `FingerTree[A]`
fn[A] FingerTree::snoc_tree(
  finger_tree : FingerTree[A],
  tree : Tree[A],
) -> FingerTree[A] {
  match (finger_tree, tree) {
    // case 1:
    (Empty, a) => FingerTree::Single(a)
    // case 2:
    (Single(Single(b)), Single(a)) =>
      FingerTree::Deep(Deep(One(b)), spine_val(Empty), Deep(One(a)))
    (Single(SingleNode(b)), SingleNode(a)) =>
      FingerTree::Deep(DeepNode(One(b)), spine_val(Empty), DeepNode(One(a)))
    // case 3:
    (Deep(pf, m, Deep(Four(e, d, c, b))), Single(a)) => {
      let prefix = pf
      let node3 : Tree[A] = SingleNode(Node3(Single(e), Single(d), Single(c)))
      let middle = spine(fn() { FingerTree::snoc_tree(m.force(), node3) })
      let suffix = Tree::Deep(Two(b, a))
      FingerTree::Deep(prefix, middle, suffix)
    }
    (Deep(pf, m, DeepNode(Four(e, d, c, b))), SingleNode(a)) => {
      let prefix = pf
      let node3 = SingleNode(Node3(SingleNode(e), SingleNode(d), SingleNode(c)))
      let middle = spine(fn() { FingerTree::snoc_tree(m.force(), node3) })
      let suffix = Tree::DeepNode(Two(b, a))
      FingerTree::Deep(prefix, middle, suffix)
    }
    // case 4:
    (Deep(pf, m, Deep(sf)), Single(a)) => {
      let prefix = pf
      let middle = m
      let suffix = Tree::Deep(Digit::snoc(sf, a))
      FingerTree::Deep(prefix, middle, suffix)
    }
    (Deep(pf, m, DeepNode(sf)), SingleNode(a)) => {
      let prefix = pf
      let middle = m
      let suffix = Tree::DeepNode(Digit::snoc(sf, a))
      FingerTree::Deep(prefix, middle, suffix)
    }
    (Single(Single(_)), SingleNode(_)) | (Single(SingleNode(_)), Single(_)) =>
      abort("due to the finger tree structure for case 2")
    (Deep(_, _, DeepNode(_)), Single(_))
    | (Deep(_, _, Deep(_)), SingleNode(_)) =>
      abort("due to the finger tree structure for case 3")
    (_, Deep(_) | DeepNode(_)) =>
      abort("due to the type refine to `Single[A] | SingleNode[A]`")
    (
      Deep(_, _, Single(_) | SingleNode(_))
      | Single(Deep(_))
      | Single(DeepNode(_)),
      Single(_)
      | SingleNode(_),
    ) =>
      abort(
        "due to the type regine to `Deep(Digit[A]) | DeepNode(Digit[Node[Tree[A]]])`",
      )
  }
}

///|
pub fn[A] FingerTree::snoc(xs : FingerTree[A], x : A) -> FingerTree[A] {
  FingerTree::snoc_tree(xs, Tree::Single(x))
}
