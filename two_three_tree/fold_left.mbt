///|
pub fn[A, B] Tree::fold_left(self : Tree[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    Empty => acc
    Two(left, value, right) => {
      let acc1 = Tree::fold_left(left, acc, f)
      let acc2 = f(acc1, value)
      Tree::fold_left(right, acc2, f)
    }
    Three(left, value1, middle, value2, right) => {
      let acc1 = Tree::fold_left(left, acc, f)
      let acc2 = f(acc1, value1)
      let acc3 = Tree::fold_left(middle, acc2, f)
      let acc4 = f(acc3, value2)
      Tree::fold_left(right, acc4, f)
    }
    Four(left, value1, m1, value2, m2, value3, right) => {
      let acc1 = Tree::fold_left(left, acc, f)
      let acc2 = f(acc1, value1)
      let acc3 = Tree::fold_left(m1, acc2, f)
      let acc4 = f(acc3, value2)
      let acc5 = Tree::fold_left(m2, acc4, f)
      let acc6 = f(acc5, value3)
      Tree::fold_left(right, acc6, f)
    }
  }
}
