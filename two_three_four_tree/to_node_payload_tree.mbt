///|
pub fn[A : Show] TwoThreeFourTree::to_node_payload_tree(
  tree : TwoThreeFourTree[A],
) -> @graphviz.NodePayloadTree {
  match tree {
    Empty => { label: "NIL", children: [] }
    Two(left, x, right) =>
      {
        label: x.to_string(),
        children: Array::map(
          [left, right],
          TwoThreeFourTree::to_node_payload_tree,
        ),
      }
    Three(left, x, middle, y, right) =>
      {
        label: Array::to_string([x, y]),
        children: Array::map(
          [left, middle, right],
          TwoThreeFourTree::to_node_payload_tree,
        ),
      }
    Four(left, x, m1, y, m2, z, right) =>
      {
        label: Array::to_string([x, y, z]),
        children: Array::map(
          [left, m1, m2, right],
          TwoThreeFourTree::to_node_payload_tree,
        ),
      }
  }
}
