///|
pub fn[A] FingerTree::concat(
  left : FingerTree[A],
  right : FingerTree[A],
) -> FingerTree[A] {
  match (left, right) {
    (Empty, xs) => xs
    (xs, Empty) => xs
    (Single(x), xs) => FingerTree::cons_tree(x, xs)
    (xs, Single(x)) => FingerTree::snoc_tree(xs, x)
    (Deep(pr1, m1, sf1), Deep(pr2, m2, sf2)) => {
      let prefix = pr1
      let middle = FingerTree::append3_aux(
        m1,
        Tree::nodes(DeepNode(One(Node2(sf1, pr2)))),
        m2,
      )
      let suffix = sf2
      Deep(prefix, middle, suffix)
    }
  }
}

///|
fn[A] FingerTree::append3_aux(
  left : FingerTree[A],
  middle : Tree[A],
  right : FingerTree[A],
) -> FingerTree[A] {
  match (left, right) {
    (Empty, xs) => FingerTree::cons_tree(middle, xs)
    (xs, Empty) => FingerTree::snoc_tree(xs, middle)
    (Single(x), xs) =>
      FingerTree::cons_tree(x, FingerTree::cons_tree(middle, xs))
    (xs, Single(x)) =>
      FingerTree::snoc_tree(FingerTree::snoc_tree(xs, middle), x)
    (Deep(pr1, m1, sf1), Deep(pr2, m2, sf2)) => {
      let prefix = pr1
      let middle = FingerTree::append3_aux(
        m1,
        Tree::nodes(DeepNode(One(Node3(sf1, middle, pr2)))),
        m2,
      )
      let suffix = sf2
      Deep(prefix, middle, suffix)
    }
  }
}

///|
/// - `param`: tree refine to `Deep(Digit[A])` or `DeepNode(Digit[Node[Tree[A]]])`
/// - `return`:  type refine to `Single(A)` or  `SingleNode(Node[Tree[A]])`
fn[A] Tree::nodes(tree : Tree[A]) -> Tree[A] {
  guard tree is DeepNode(One(node)) else { abort("impossible") }
  match node {
    Node2(a, b) => Tree::node_aux2(a, b)
    Node3(a, b, c) => Tree::node_aux3(a, b, c)
  }
}

///|
/// - `param`: left refine to `Deep(Digit[A])` or `DeepNode(Digit[Node[Tree[A]]])`
/// - `param`: right refine to `Deep(Digit[A])` or `DeepNode(Digit[Node[Tree[A]]])`
/// - `return`:  type refine to `Single[A]` or  `SingleNode[Node[Tree[A]]]`
fn[A] Tree::node_aux2(left : Tree[A], right : Tree[A]) -> Tree[A] {
  fn node2(a : Tree[A], b : Tree[A]) -> Tree[A] {
    SingleNode(Node2(a, b))
  }

  fn node3(a : Tree[A], b : Tree[A], c : Tree[A]) -> Tree[A] {
    SingleNode(Node3(a, b, c))
  }

  match (left, right) {

    (Deep(left), Deep(right)) => {
      let leaf = Tree::Single(_)
      match (left, right) {
        (One(a), One(b)) => node2(leaf(a), leaf(b))
        (One(a), Two(b, c)) => node3(leaf(a), leaf(b), leaf(c))
        (One(a), Three(b, c, d)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node2(leaf(c), leaf(d))
          node2(left_node, right_node)
        }
        (One(a), Four(b, c, d, e)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Two(a, b), One(c)) => node3(leaf(a), leaf(b), leaf(c))
        (Two(a, b), Two(c, d)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node2(leaf(c), leaf(d))
          node2(left_node, right_node)
        }
        (Two(a, b), Three(c, d, e)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Two(a, b), Four(c, d, e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(d), leaf(e), leaf(f))
          node2(left_node, right_node)
        }
        (Three(a, b, c), One(d)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node2(leaf(c), leaf(d))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Two(d, e)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Three(d, e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(d), leaf(e), leaf(f))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Four(d, e, f, g)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node2(leaf(d), leaf(e))
          let right_node = node2(leaf(f), leaf(g))
          node3(left_node, middle_node, right_node)
        }
        (Four(a, b, c, d), One(e)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Four(a, b, c, d), Two(e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(d), leaf(e), leaf(f))
          node2(left_node, right_node)
        }
        (Four(a, b, c, d), Three(e, f, g)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node2(leaf(d), leaf(e))
          let right_node = node2(leaf(f), leaf(g))
          node3(left_node, middle_node, right_node)
        }
        (Four(a, b, c, d), Four(e, f, g, h)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node3(leaf(d), leaf(e), leaf(f))
          let right_node = node2(leaf(g), leaf(h))
          node3(left_node, middle_node, right_node)
        }
      }
    }

    (DeepNode(left), DeepNode(right)) => {
      let leaf = Tree::SingleNode(_)
      match (left, right) {
        (One(a), One(b)) => node2(leaf(a), leaf(b))
        (One(a), Two(b, c)) => node3(leaf(a), leaf(b), leaf(c))
        (One(a), Three(b, c, d)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node2(leaf(c), leaf(d))
          node2(left_node, right_node)
        }
        (One(a), Four(b, c, d, e)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Two(a, b), One(c)) => node3(leaf(a), leaf(b), leaf(c))
        (Two(a, b), Two(c, d)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node2(leaf(c), leaf(d))
          node2(left_node, right_node)
        }
        (Two(a, b), Three(c, d, e)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Two(a, b), Four(c, d, e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(d), leaf(e), leaf(f))
          node2(left_node, right_node)
        }
        (Three(a, b, c), One(d)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node2(leaf(c), leaf(d))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Two(d, e)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Three(d, e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(d), leaf(e), leaf(f))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Four(d, e, f, g)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node2(leaf(d), leaf(e))
          let right_node = node2(leaf(f), leaf(g))
          node3(left_node, middle_node, right_node)
        }
        (Four(a, b, c, d), One(e)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Four(a, b, c, d), Two(e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(d), leaf(e), leaf(f))
          node2(left_node, right_node)
        }
        (Four(a, b, c, d), Three(e, f, g)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node2(leaf(d), leaf(e))
          let right_node = node2(leaf(f), leaf(g))
          node3(left_node, middle_node, right_node)
        }
        (Four(a, b, c, d), Four(e, f, g, h)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node3(leaf(d), leaf(e), leaf(f))
          let right_node = node2(leaf(g), leaf(h))
          node3(left_node, middle_node, right_node)
        }
      }
    }
    (_, _) =>
      abort(
        "dut to type refine to `Deep(Digit[A])` or `DeepNode(Digit[Node[Tree[A]]])`",
      )
  }
}

///|
/// - `param`: left refine to `Deep(Digit[A])` or `DeepNode(Digit[Node[Tree[A]]])`
/// - `param`: middle refine to `Single[A]` or `SingleNode[Node[Tree[A]]]`
/// - `param`: right refine to `Deep(Digit[A])` or `DeepNode(Digit[Node[Tree[A]]])`
/// - `return`:  type refine to `Single[A]` or  `SingleNode[Node[Tree[A]]]`
fn[A] Tree::node_aux3(
  left : Tree[A],
  middle : Tree[A],
  right : Tree[A],
) -> Tree[A] {
  fn node2(a : Tree[A], b : Tree[A]) -> Tree[A] {
    SingleNode(Node2(a, b))
  }

  fn node3(a : Tree[A], b : Tree[A], c : Tree[A]) -> Tree[A] {
    SingleNode(Node3(a, b, c))
  }

  match (left, middle, right) {
    (Deep(left), Single(middle_val), Deep(right)) => {
      let leaf = Tree::Single(_)
      match (left, right) {
        (One(a), One(b)) => node3(leaf(a), leaf(middle_val), leaf(b))
        (One(a), Two(b, c)) => {
          let left_node = node2(leaf(a), leaf(middle_val))
          let right_node = node2(leaf(b), leaf(c))
          node2(left_node, right_node)
        }
        (One(a), Three(b, c, d)) => {
          let left_node = node2(leaf(a), leaf(middle_val))
          let right_node = node3(leaf(b), leaf(c), leaf(d))
          node2(left_node, right_node)
        }
        (One(a), Four(b, c, d, e)) => {
          let left_node = node3(leaf(a), leaf(middle_val), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Two(a, b), One(c)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node2(leaf(middle_val), leaf(c))
          node2(left_node, right_node)
        }
        (Two(a, b), Two(c, d)) => {
          let left_node = node2(leaf(a), leaf(b))
          let middle_node = leaf(middle_val)
          let right_node = node2(leaf(c), leaf(d))
          node3(left_node, middle_node, right_node)
        }
        (Two(a, b), Three(c, d, e)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(middle_val))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Two(a, b), Four(c, d, e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(middle_val))
          let middle_node = node2(leaf(c), leaf(d))
          let right_node = node2(leaf(e), leaf(f))
          node3(left_node, middle_node, right_node)
        }
        (Three(a, b, c), One(d)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node2(leaf(middle_val), leaf(d))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Two(d, e)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(middle_val), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Three(d, e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node2(leaf(middle_val), leaf(d))
          let right_node = node2(leaf(e), leaf(f))
          node3(left_node, middle_node, right_node)
        }
        (Three(a, b, c), Four(d, e, f, g)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node3(leaf(middle_val), leaf(d), leaf(e))
          let right_node = node2(leaf(f), leaf(g))
          node3(left_node, middle_node, right_node)
        }
        (Four(a, b, c, d), One(e)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(d), leaf(middle_val), leaf(e))
          node2(left_node, right_node)
        }
        (Four(a, b, c, d), Two(e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node2(leaf(d), leaf(middle_val))
          let right_node = node2(leaf(e), leaf(f))
          node3(left_node, middle_node, right_node)
        }
        (Four(a, b, c, d), Three(e, f, g)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node3(leaf(d), leaf(middle_val), leaf(e))
          let right_node = node2(leaf(f), leaf(g))
          node3(left_node, middle_node, right_node)
        }
        (Four(a, b, c, d), Four(e, f, g, h)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node = node3(leaf(d), leaf(middle_val), leaf(e))
          let right_node = node3(leaf(f), leaf(g), leaf(h))
          node3(left_node, middle_node, right_node)
        }
      }
    }
    (DeepNode(left), SingleNode(middle_node), DeepNode(right)) => {
      let leaf = Tree::SingleNode(_)
      match (left, right) {
        (One(a), One(b)) => node3(leaf(a), leaf(middle_node), leaf(b))
        (One(a), Two(b, c)) => {
          let left_node = node2(leaf(a), leaf(middle_node))
          let right_node = node2(leaf(b), leaf(c))
          node2(left_node, right_node)
        }
        (One(a), Three(b, c, d)) => {
          let left_node = node2(leaf(a), leaf(middle_node))
          let right_node = node3(leaf(b), leaf(c), leaf(d))
          node2(left_node, right_node)
        }
        (One(a), Four(b, c, d, e)) => {
          let left_node = node3(leaf(a), leaf(middle_node), leaf(b))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Two(a, b), One(c)) => {
          let left_node = node2(leaf(a), leaf(b))
          let right_node = node2(leaf(middle_node), leaf(c))
          node2(left_node, right_node)
        }
        (Two(a, b), Two(c, d)) => {
          let left_node = node2(leaf(a), leaf(b))
          let middle_node_tree = leaf(middle_node)
          let right_node = node2(leaf(c), leaf(d))
          node3(left_node, middle_node_tree, right_node)
        }
        (Two(a, b), Three(c, d, e)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(middle_node))
          let right_node = node3(leaf(c), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Two(a, b), Four(c, d, e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(middle_node))
          let middle_node_tree = node2(leaf(c), leaf(d))
          let right_node = node2(leaf(e), leaf(f))
          node3(left_node, middle_node_tree, right_node)
        }
        (Three(a, b, c), One(d)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node2(leaf(middle_node), leaf(d))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Two(d, e)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(middle_node), leaf(d), leaf(e))
          node2(left_node, right_node)
        }
        (Three(a, b, c), Three(d, e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node_tree = node2(leaf(middle_node), leaf(d))
          let right_node = node2(leaf(e), leaf(f))
          node3(left_node, middle_node_tree, right_node)
        }
        (Three(a, b, c), Four(d, e, f, g)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node_tree = node3(leaf(middle_node), leaf(d), leaf(e))
          let right_node = node2(leaf(f), leaf(g))
          node3(left_node, middle_node_tree, right_node)
        }
        (Four(a, b, c, d), One(e)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let right_node = node3(leaf(d), leaf(middle_node), leaf(e))
          node2(left_node, right_node)
        }
        (Four(a, b, c, d), Two(e, f)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node_tree = node2(leaf(d), leaf(middle_node))
          let right_node = node2(leaf(e), leaf(f))
          node3(left_node, middle_node_tree, right_node)
        }
        (Four(a, b, c, d), Three(e, f, g)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node_tree = node3(leaf(d), leaf(middle_node), leaf(e))
          let right_node = node2(leaf(f), leaf(g))
          node3(left_node, middle_node_tree, right_node)
        }
        (Four(a, b, c, d), Four(e, f, g, h)) => {
          let left_node = node3(leaf(a), leaf(b), leaf(c))
          let middle_node_tree = node3(leaf(d), leaf(middle_node), leaf(e))
          let right_node = node3(leaf(f), leaf(g), leaf(h))
          node3(left_node, middle_node_tree, right_node)
        }
      }
    }
    (_, _, _) =>
      abort(
        "dut to type refine to `Deep(Digit[A])` or `DeepNode(Digit[Node[Tree[A]]])`",
      )
  }
}
