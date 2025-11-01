///|
using @finger_tree {type FingerTree}

///|
using @illusory0x0/list {type List}

///|
using @two_three_four_tree {type TwoThreeFourTree}

///|
using @two_three_tree {type TwoThreeTree}

///|
using @finger_tree_strict {type FingerTree as FingerTreeStrict}

///|
test (b : @bench.T) {
  let len = 10000
  b.bench(name="finger_tree::cons", fn() {
    let mut xs = FingerTree::empty()
    for i in 0..<len {
      xs = FingerTree::cons(i, xs)
    }
  })
  b.bench(name="finger_tree_strict::cons", fn() {
    let mut xs = FingerTreeStrict::empty()
    for i in 0..<len {
      xs = FingerTreeStrict::cons(i, xs)
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
