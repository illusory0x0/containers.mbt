///|
typealias @list.List

///|
fn[A] TwoThreeTree::to_list(tree : TwoThreeTree[A]) -> List[A] {
  tree.fold_left(@list.empty(), (acc, x) => @list.cons(x, acc))
}

///|
test "cons" (t : @test.T) {
  let mut tree = TwoThreeTree::empty()
  for x in 1..=36 {
    tree = TwoThreeTree::cons(x, tree)
  }
  inspect(
    tree.to_list(),
    content="@list.of([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36])",
  )
  let g = tree.to_node_payload_tree()
  t.writeln(g.to_digraph())
  t.snapshot(filename="two_three_tree_cons.dot")
}

///|
test "snoc" (t : @test.T) {
  let mut tree = TwoThreeTree::empty()
  for x in 1..=36 {
    tree = TwoThreeTree::snoc(tree, x)
  }
  inspect(
    tree.to_list(),
    content="@list.of([36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1])",
  )
  let g = tree.to_node_payload_tree()
  t.writeln(g.to_digraph())
  t.snapshot(filename="two_three_tree_snoc.dot")
}

///|
test "balance: cons/uncons" {
  let mut tree = TwoThreeTree::empty()
  let heights = []
  for x in 1..=36 {
    heights.push(tree.height())
    tree = TwoThreeTree::cons(x, tree)
  }
  inspect(
    heights,
    content="[0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5]",
  )
  let heights = []
  for _ in 1..<36 {
    heights.push(tree.height())
    guard TwoThreeTree::uncons(tree) is Cons(_, tree_) else { break }
    tree = tree_
  }
  inspect(
    heights,
    content="[5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 1]",
  )
}

///|
test "balance: snoc/unsnoc" {
  let mut tree = TwoThreeTree::empty()
  let height = []
  for x in 1..=36 {
    height.push(tree.height())
    tree = TwoThreeTree::snoc(tree, x)
  }
  inspect(
    height,
    content="[0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5]",
  )
  let heights = []
  for _ in 1..<36 {
    heights.push(tree.height())
    guard TwoThreeTree::unsnoc(tree) is Snoc(tree_, _) else { break }
    tree = tree_
  }
  inspect(
    heights,
    content="[5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 1]",
  )
}
