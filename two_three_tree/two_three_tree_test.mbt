///|
test (t : @test.T) {
  let mut tree = Tree::empty()
  for x in 1..=36 {
    tree = Tree::cons(x, tree)
  }
  let g = tree.to_node_payload_tree()
  t.writeln(g.to_digraph())
  t.snapshot(filename="two_three_tree_cons.dot")
}

///|
test (t : @test.T) {
  let mut tree = Tree::empty()
  for x in 1..=36 {
    tree = Tree::snoc(tree, x)
  }
  let g = tree.to_node_payload_tree()
  t.writeln(g.to_digraph())
  t.snapshot(filename="two_three_tree_snoc.dot")
}
