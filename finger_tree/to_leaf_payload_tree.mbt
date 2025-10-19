///|
pub fn[A : Show] FingerTree::to_leaf_payload_tree(
  self : FingerTree[A],
) -> @graphviz.LeafPayloadTree {
  match self {
    Empty => Children([])
    Single(tree) => tree.to_leaf_payload_tree()
    Deep(prefix, middle, suffix) =>
      Children([
        prefix.to_leaf_payload_tree(),
        middle.force().to_leaf_payload_tree(),
        suffix.to_leaf_payload_tree(),
      ])
  }
}

///|
fn[A : Show] Tree::to_leaf_payload_tree(
  self : Tree[A],
) -> @graphviz.LeafPayloadTree {
  match self {
    Single(a) => Leaf(a.to_string())
    SingleNode(a) => a.to_leaf_payload_tree()
    Deep(pr) => pr.to_leaf_payload_tree(x => Leaf(x.to_string()))
    DeepNode(pr) => pr.to_leaf_payload_tree(Node::to_leaf_payload_tree)
  }
}

///|
fn[A] Digit::to_leaf_payload_tree(
  self : Digit[A],
  f : (A) -> @graphviz.LeafPayloadTree,
) -> @graphviz.LeafPayloadTree {
  match self {
    One(a) => f(a)
    Two(a, b) => Children([f(a), f(b)])
    Three(a, b, c) => Children([f(a), f(b), f(c)])
    Four(a, b, c, d) => Children([f(a), f(b), f(c), f(d)])
  }
}

///|
fn[A : Show] Node::to_leaf_payload_tree(
  self : Node[Tree[A]],
) -> @graphviz.LeafPayloadTree {
  match self {
    Node2(a, b) =>
      Children([a.to_leaf_payload_tree(), b.to_leaf_payload_tree()])
    Node3(a, b, c) =>
      Children([
        a.to_leaf_payload_tree(),
        b.to_leaf_payload_tree(),
        c.to_leaf_payload_tree(),
      ])
  }
}
