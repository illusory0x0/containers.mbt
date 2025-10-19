///|
pub fn[A] TwoThreeFourTree::snoc(
  ws : TwoThreeFourTree[A],
  w : A,
) -> TwoThreeFourTree[A] {
  match ws {
    Two(Empty, x, Empty) => Three(Empty, x, Empty, w, Empty)
    Three(Empty, x, Empty, y, Empty) =>
      Four(Empty, x, Empty, y, Empty, w, Empty)
    Four(Empty, x, Empty, y, Empty, z, Empty) =>
      Two(Two(Empty, x, Empty), y, Three(Empty, z, Empty, w, Empty))
    Three(left, x, m2, y, Two(_) | Three(_) | Four(_) as right) =>
      match TwoThreeFourTree::snoc(right, w) {
        Two(m1, w, right) => Four(left, x, m2, y, m1, w, right)
        _ as right => Three(left, x, m2, y, right)
      }
    Two(left, x, Two(_) | Three(_) | Four(_) as right) =>
      match TwoThreeFourTree::snoc(right, w) {
        Two(middle, w, right) => Three(left, x, middle, w, right)
        _ as right => Two(left, x, right)
      }
    Four(left, x, m2, y, m3, z, Two(_) | Three(_) | Four(_) as right) =>
      match TwoThreeFourTree::snoc(right, w) {
        Two(m1, w, right) =>
          Two(Two(left, x, m2), y, Three(m3, z, m1, w, right))
        _ as right => Four(left, x, m2, y, m3, z, right)
      }
    Empty => Two(Empty, w, Empty)
    Two(_, _, Empty)
    | Three(_, _, _, _, Empty)
    | Four(_, _, _, _, _, _, Empty) => panic()
  }
}
