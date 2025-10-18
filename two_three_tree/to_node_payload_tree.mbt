///|
pub fn[A : Show] Tree::to_node_payload_tree(
  tree : Tree[A],
) -> @graphviz.NodePayloadTree {
  match tree {
    Empty => { label: "NIL", children: [] }
    Two(left, x, right) =>
      {
        label: x.to_string(),
        children: Array::map([left, right], Tree::to_node_payload_tree),
      }
    Three(left, x, middle, y, right) =>
      {
        label: Array::to_string([x, y]),
        children: Array::map([left, middle, right], Tree::to_node_payload_tree),
      }
    Four(left, x, m1, y, m2, z, right) =>
      {
        label: Array::to_string([x, y, z]),
        children: Array::map([left, m1, m2, right], Tree::to_node_payload_tree),
      }
  }
}
