///|
struct Vector[A](FixedArray[A])

///|
pub fn[A] Vector::op_get(self : Vector[A], index : Int) -> A = "%fixedarray.unsafe_get"

///|
pub fn[A] Vector::length(self : Vector[A]) -> Int = "%fixedarray.length"

///|
pub fn[A] Vector::make(len : Int, value : A) -> Vector[A] = "%fixedarray.make"

///|
pub fn[A] Vector::op_as_view(
  self : Vector[A],
  start? : Int = 0,
  end? : Int = self.length(),
) -> ArrayView[A] {
  FixedArray::op_as_view(self.0, start~, end~)
}

///|
#locals(f)
pub fn[A] Vector::makei(len : Int, f : (Int) -> A) -> Vector[A] {
  guard len >= 0 else { abort("`len` must be non-negative") }
  if len == 0 {
    []
  } else {
    let result = Vector::make(len, f(0))
    for i in 1..<len {
      result.0[i] = f(i)
    }
    result
  }
}

///|
#locals(f)
pub fn[A] Vector::update(
  self : Vector[A],
  f : (FixedArray[A]) -> Unit,
) -> Vector[A] {
  let result = self.0.copy()
  f(result)
  Vector(result)
}
