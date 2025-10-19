///|
pub fn[A] TwoThreeFourTree::cons(
  w : A,
  ws : TwoThreeFourTree[A],
) -> TwoThreeFourTree[A] {
  match ws {
    Two(Empty, x, Empty) => Three(Empty, w, Empty, x, Empty)
    Three(Empty, x, Empty, y, Empty) =>
      Four(Empty, w, Empty, x, Empty, y, Empty)
    Four(Empty, x, Empty, y, Empty, z, Empty) =>
      Two(Three(Empty, w, Empty, x, Empty), y, Two(Empty, z, Empty))
    Three(Two(_) | Three(_) | Four(_) as left, x, m2, y, right) =>
      match TwoThreeFourTree::cons(w, left) {
        Two(left, w, m1) => Four(left, w, m1, x, m2, y, right)
        _ as left => Three(left, x, m2, y, right)
      }
    Two(Two(_) | Three(_) | Four(_) as left, x, right) =>
      match TwoThreeFourTree::cons(w, left) {
        Two(left, w, middle) => Three(left, w, middle, x, right)
        _ as left => Two(left, x, right)
      }
    Four(Two(_) | Three(_) | Four(_) as left, x, m2, y, m3, z, right) =>
      match TwoThreeFourTree::cons(w, left) {
        Two(left, w, m1) => Two(Three(left, w, m1, x, m2), y, Two(m3, z, right))
        _ as left => Four(left, x, m2, y, m3, z, right)
      }
    Empty => Two(Empty, w, Empty)
    Two(Empty, _, _)
    | Three(Empty, _, _, _, _)
    | Four(Empty, _, _, _, _, _, _) => panic()
  }
}
