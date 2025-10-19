///|
typealias @finger_tree.FingerTree

///|
typealias @illusory0x0/containers/list.List

///|
typealias @two_three_four_tree.TwoThreeFourTree

///|
typealias @two_three_tree.TwoThreeTree

///|
test (b : @bench.T) {
  let len = 1024
  b.bench(name="finger_tree::cons", fn() {
    let mut xs = FingerTree::empty()
    for i in 0..<len {
      xs = FingerTree::cons(i, xs)
    }
  })
  b.bench(name="two_three_tree::cons", fn() {
    let mut xs = TwoThreeTree::empty()
    for i in 0..<len {
      xs = TwoThreeTree::cons(i, xs)
    }
  })
  b.bench(name="two_three_four_tree::cons", fn() {
    let mut xs = TwoThreeFourTree::empty()
    for i in 0..<len {
      xs = TwoThreeFourTree::cons(i, xs)
    }
  })
  b.bench(name="list::cons", fn() {
    let mut xs = List::Nil
    for i in 0..<len {
      xs = List::Cons(i, xs)
    }
  })
}
