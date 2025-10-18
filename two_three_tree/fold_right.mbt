///|
pub fn[A, B] TwoThreeTree::fold_right(
  self : TwoThreeTree[A],
  acc : B,
  f : (B, A) -> B,
) -> B {
  match self {
    Empty => acc
    Two(left, value, right) => {
      let acc1 = TwoThreeTree::fold_right(right, acc, f)
      let acc2 = f(acc1, value)
      TwoThreeTree::fold_right(left, acc2, f)
    }
    Three(left, value1, middle, value2, right) => {
      let acc1 = TwoThreeTree::fold_right(right, acc, f)
      let acc2 = f(acc1, value2)
      let acc3 = TwoThreeTree::fold_right(middle, acc2, f)
      let acc4 = f(acc3, value1)
      TwoThreeTree::fold_right(left, acc4, f)
    }
    Four(left, value1, m1, value2, m2, value3, right) => {
      let acc1 = TwoThreeTree::fold_right(right, acc, f)
      let acc2 = f(acc1, value3)
      let acc3 = TwoThreeTree::fold_right(m2, acc2, f)
      let acc4 = f(acc3, value2)
      let acc5 = TwoThreeTree::fold_right(m1, acc4, f)
      let acc6 = f(acc5, value1)
      TwoThreeTree::fold_right(left, acc6, f)
    }
  }
}
