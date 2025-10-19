///|
typealias @list.List

///|
fn[A] TwoThreeFourTree::to_list(tree : TwoThreeFourTree[A]) -> List[A] {
  tree.fold_left(List::empty(), (acc, x) => List::cons(x, acc))
}

///|
test "cons" (t : @test.T) {
  let mut tree = TwoThreeFourTree::empty()
  for x in 0..<32 {
    tree = TwoThreeFourTree::cons(x, tree)
  }
  inspect(
    tree.to_list(),
    content="@list.of([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31])",
  )
  t.writeln(tree.to_node_payload_tree().to_digraph())
  t.snapshot(filename="two_three_four_cons.dot")
}

///|
test "snoc" (t : @test.T) {
  let mut tree = TwoThreeFourTree::empty()
  for x in 0..<32 {
    tree = TwoThreeFourTree::snoc(tree, x)
  }
  inspect(
    tree.to_list(),
    content="@list.of([31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0])",
  )
  t.writeln(tree.to_node_payload_tree().to_digraph())
  t.snapshot(filename="two_three_four_snoc.dot")
}

///|
test "balance: cons/uncons" {
  let mut tree = TwoThreeFourTree::empty()
  let heights = []
  for x in 1..=36 {
    heights.push(tree.height())
    tree = TwoThreeFourTree::cons(x, tree)
  }
  inspect(
    heights,
    content="[0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]",
  )
  let heights = []
  for _ in 1..=36 {
    heights.push(tree.height())
    guard TwoThreeFourTree::uncons(tree) is Cons(_, tree_) else { break }
    tree = tree_
  }
  inspect(
    heights,
    content="[4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1]",
  )
}

///|
test "balance: snoc/unsnoc" {
  let mut tree = TwoThreeFourTree::empty()
  let heights = []
  for x in 1..=36 {
    heights.push(tree.height())
    tree = TwoThreeFourTree::snoc(tree, x)
  }
  inspect(
    heights,
    content="[0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]",
  )
  let heights = []
  for _ in 1..=36 {
    heights.push(tree.height())
    guard TwoThreeFourTree::unsnoc(tree) is Snoc(tree_, _) else { break }
    tree = tree_
  }
  inspect(
    heights,
    content="[4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1]",
  )
}
