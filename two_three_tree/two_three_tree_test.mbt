test (t : @test.T){
  let mut tree = Tree::emtpy()
  for x in 1..=36 {
    tree = Tree::cons(x,tree)
  }
  let g = tree.to_node_payload_tree()
  t.writeln(g.to_digraph())
  t.snapshot(filename="two_three_tree_cons.dot")
}