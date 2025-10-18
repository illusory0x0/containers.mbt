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

///|
test "fold_left empty tree" {
  let tree : Tree[Int] = Tree::empty()
  let result = tree.fold_left(0, fn(acc, x) { acc + x })
  inspect(result, content="0")
}

///|
test "fold_left single element tree" {
  let tree = Tree::cons(5, Tree::empty())
  let result = tree.fold_left(0, fn(acc, x) { acc + x })
  inspect(result, content="5")
}

///|
test "fold_left multiple elements - sum" {
  let mut tree = Tree::empty()
  for x in [1, 2, 3, 4, 5] {
    tree = Tree::cons(x, tree)
  }
  let result = tree.fold_left(0, fn(acc, x) { acc + x })
  inspect(result, content="15")
}

///|
test "fold_left multiple elements - list construction" {
  let mut tree = Tree::empty()
  for x in [1, 2, 3] {
    tree = Tree::cons(x, tree)
  }
  let result = tree.fold_left([], fn(acc, x) { [x, ..acc] })
  inspect(result, content="[1, 2, 3]")
}

///|
test "fold_right empty tree" {
  let tree : Tree[Int] = Tree::empty()
  let result = tree.fold_right(0, fn(acc, x) { acc + x })
  inspect(result, content="0")
}

///|
test "fold_right single element tree" {
  let tree = Tree::cons(5, Tree::empty())
  let result = tree.fold_right(0, fn(acc, x) { acc + x })
  inspect(result, content="5")
}

///|
test "fold_right multiple elements - sum" {
  let mut tree = Tree::empty()
  for x in [1, 2, 3, 4, 5] {
    tree = Tree::cons(x, tree)
  }
  let result = tree.fold_right(0, fn(acc, x) { acc + x })
  inspect(result, content="15")
}

///|
test "fold_right multiple elements - list construction" {
  let mut tree = Tree::empty()
  for x in [1, 2, 3] {
    tree = Tree::cons(x, tree)
  }
  let result = tree.fold_right([], fn(acc, x) { [x, ..acc] })
  inspect(result, content="[3, 2, 1]")
}

///|
test "fold_left vs fold_right ordering" {
  let mut tree = Tree::empty()
  for x in [1, 2, 3, 4] {
    tree = Tree::cons(x, tree)
  }

  // Test with non-commutative operation (subtraction)
  let left_result = tree.fold_left(0, fn(acc, x) { acc - x })
  let right_result = tree.fold_right(0, fn(acc, x) { acc - x })
  inspect(left_result, content="-10")
  inspect(right_result, content="-10")
}

///|
test "fold_left with snoc operations" {
  let mut tree = Tree::empty()
  for x in [1, 2, 3, 4] {
    tree = Tree::snoc(tree, x)
  }
  let result = tree.fold_left(0, fn(acc, x) { acc + x })
  inspect(result, content="10")
}

///|
test "fold_right with snoc operations" {
  let mut tree = Tree::empty()
  for x in [1, 2, 3, 4] {
    tree = Tree::snoc(tree, x)
  }
  let result = tree.fold_right(0, fn(acc, x) { acc + x })
  inspect(result, content="10")
}
