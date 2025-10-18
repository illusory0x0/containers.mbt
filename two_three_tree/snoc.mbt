///|
fn[A] Tree::snoc_aux(xs : Tree[A], x : A) -> Tree[A] {
  match xs {
    Two(Empty, y, Empty) => Three(Empty, y, Empty, x, Empty)
    Three(Empty, y, Empty, z, Empty) =>
      Four(Empty, y, Empty, z, Empty, x, Empty)
    Two(left, z, Two(_) | Three(_) as right) =>
      match Tree::snoc_aux(right, x) {
        Four(m1, w, m2, x, m3, y, right) => {
          // number is the payload
          //
          // Two(_,Four(_))    ->    Three(_,Two(_),Two(_))
          //        |                        |
          //        |                       / \
          //        |                      /   \  
          //        1                     1     1
          //       / \                   / \   / \   
          //      /   \                 /   \ /   \
          //     _   /|\               _     |     |
          //        / | \                    |     |
          //       1  1  1                   1     1
          //
          let tree = Three(left, z, Two(m1, w, m2), x, Two(m3, y, right))
          tree
        }
        _ as right => Two(left, z, right)
      }
    Three(left, y, middle, z, Two(_) | Three(_) as right) =>
      match Tree::snoc_aux(right, x) {
        Four(m1, v, m2, w, m3, x, right) =>
          // number is the payload
          //
          //   Three(_,_,Four(_))    ->    Four(_,_,Two(_),Two(_))
          //                 |                          |
          //                / \                        /|\
          //               /   \                      / | \
          //              1     1                    1  1  1
          //                     \                        \   \
          //                      \                        \   \   
          //                      /|\                       |    |            
          //                     / | \                      |    |          
          //                    1  1  1                     1    1        
          Four(left, y, middle, z, Two(m1, v, m2), w, Two(m3, x, right))
        _ as right => Three(left, y, middle, z, right)
      }
    Empty => Two(Empty, x, Empty)
    Two(_, _, Empty | Four(_)) | Three(_, _, _, _, Empty | Four(_)) | Four(_) =>
      panic()
  }
}

///|
pub fn[A] Tree::snoc(xs : Tree[A], x : A) -> Tree[A] {
  match Tree::snoc_aux(xs, x) {
    Four(left, x, m1, y, m2, z, right) =>
      Two(Two(left, x, m1), y, Two(m2, z, right))
    _ as tree => tree
  }
}
