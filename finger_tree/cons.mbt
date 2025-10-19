///|
fn[A] Digit::cons(a : A, digit : Digit[A]) -> Digit[A] {
  match digit {
    One(b) => Digit::Two(a, b)
    Two(b, c) => Digit::Three(a, b, c)
    Three(b, c, d) => Digit::Four(a, b, c, d)
    Four(_, _, _, _) => abort("cannot cons to a Four")
  }
}

///|
/// - `param`: `tree` refine to `Single[A]` or `SingleNode[A]`
/// - `param`: `finger_tree`
/// - `return`: `FingerTree[A]`
fn[A] FingerTree::cons_tree(
  tree : Tree[A],
  finger_tree : FingerTree[A],
) -> FingerTree[A] {
  match (tree, finger_tree) {
    // case 1:
    (a, Empty) => FingerTree::Single(a)
    // case 2:
    (Single(a), Single(Single(b))) =>
      FingerTree::Deep(Deep(One(a)), spine_val(Empty), Deep(One(b)))
    (SingleNode(a), Single(SingleNode(b))) =>
      FingerTree::Deep(DeepNode(One(a)), spine_val(Empty), DeepNode(One(b)))
    // case 3:
    (Single(a), Deep(Deep(Four(b, c, d, e)), m, sf)) => {
      let prefix = Tree::Deep(Two(a, b))
      let node3 : Tree[A] = SingleNode(Node3(Single(c), Single(d), Single(e)))
      let middle = spine(fn() { FingerTree::cons_tree(node3, m.force()) })
      let suffix = sf
      FingerTree::Deep(prefix, middle, suffix)
    }
    (SingleNode(a), Deep(DeepNode(Four(b, c, d, e)), m, sf)) => {
      let prefix = Tree::DeepNode(Two(a, b))
      let node3 = SingleNode(Node3(SingleNode(c), SingleNode(d), SingleNode(e)))
      let middle = spine(fn() { FingerTree::cons_tree(node3, m.force()) })
      let suffix = sf
      FingerTree::Deep(prefix, middle, suffix)
    }
    // case 4:
    (Single(a), Deep(Deep(pr), m, sf)) => {
      let prefix = Tree::Deep(Digit::cons(a, pr))
      let middle = m
      let suffix = sf
      FingerTree::Deep(prefix, middle, suffix)
    }
    (SingleNode(a), Deep(DeepNode(pr), m, sf)) => {
      let prefix = Tree::DeepNode(Digit::cons(a, pr))
      let middle = m
      let suffix = sf
      FingerTree::Deep(prefix, middle, suffix)
    }
    (Single(_), Single(SingleNode(_))) | (SingleNode(_), Single(Single(_))) =>
      abort("due to the finger tree structure for case 2")
    (Single(_), Deep(DeepNode(_), _, _))
    | (SingleNode(_), Deep(Deep(_), _, _)) =>
      abort("due to the finger tree structure for case 3")
    (Deep(_) | DeepNode(_), _) =>
      abort("due to the type refine to `Single[A] | SingleNode[A]`")
    (
      Single(_)
      | SingleNode(_),
      Deep(Single(_) | SingleNode(_), _, _)
      | Single(Deep(_))
      | Single(DeepNode(_)),
    ) =>
      abort(
        "due to the type regine to `Deep(Digit[A]) | DeepNode(Digit[Node[Tree[A]]])`",
      )
  }
}

///|
pub fn[A] FingerTree::cons(x : A, xs : FingerTree[A]) -> FingerTree[A] {
  FingerTree::cons_tree(Tree::Single(x), xs)
}
