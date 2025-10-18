///|
enum Tree[A] {
  Empty
  Two(Tree[A], A, Tree[A])
  Three(Tree[A], A, Tree[A], A, Tree[A])
  Four(Tree[A], A, Tree[A], A, Tree[A], A, Tree[A])
} derive(ToJson, Show)

pub fn[A] Tree::emtpy() -> Tree[A] {
  Empty
}