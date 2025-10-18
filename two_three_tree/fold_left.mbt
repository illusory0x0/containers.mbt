///|
pub fn[A, B] TwoThreeTree::fold_left(
  self : TwoThreeTree[A],
  acc : B,
  f : (B, A) -> B,
) -> B {
  match self {
    Empty => acc
    Two(left, value, right) => {
      let acc1 = TwoThreeTree::fold_left(left, acc, f)
      let acc2 = f(acc1, value)
      TwoThreeTree::fold_left(right, acc2, f)
    }
    Three(left, value1, middle, value2, right) => {
      let acc1 = TwoThreeTree::fold_left(left, acc, f)
      let acc2 = f(acc1, value1)
      let acc3 = TwoThreeTree::fold_left(middle, acc2, f)
      let acc4 = f(acc3, value2)
      TwoThreeTree::fold_left(right, acc4, f)
    }
    Four(_) => panic()
  }
}
