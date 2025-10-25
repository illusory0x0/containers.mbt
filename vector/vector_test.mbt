test {
  let vec = @vector.Vector::make(5,0)
  let vec2 = vec.update(vec => {
    vec[0] = 42
  })
  inspect(vec2[:], content="[42, 0, 0, 0, 0]")
}