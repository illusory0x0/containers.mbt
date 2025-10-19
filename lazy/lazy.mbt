///|
priv enum Repr[A] {
  Value(A)
  Thunk(() -> A)
}

///|
struct Lazy[A] {
  mut repr : Repr[A]
}

///|
pub fn[A] Lazy::force(self : Lazy[A]) -> A {
  match self.repr {
    Value(val) => val
    Thunk(fun) => {
      let val = fun()
      self.repr = Value(val)
      val
    }
  }
}

///|
pub fn[A] Lazy::new(fun : () -> A) -> Lazy[A] {
  Lazy::from_fun(fun)
}

///|
pub fn[A, B] Lazy::map(self : Lazy[A], f : (A) -> B) -> Lazy[B] {
  match self.repr {
    Value(val) => Lazy::from_val(f(val))
    Thunk(fun) =>
      Lazy::from_fun(fn() {
        let val = fun()
        self.repr = Value(val)
        f(val)
      })
  }
}

///|
pub fn[A] Lazy::fix(f : (Lazy[A]) -> Lazy[A]) -> Lazy[A] {
  fn fun() -> A {
    f(Lazy::from_fun(fun)).force()
  }

  Lazy::from_fun(fun)
}

///|
pub fn[A] Lazy::join(self : Lazy[Lazy[A]]) -> Lazy[A] {
  match self.repr {
    Value(val) => val
    Thunk(fun) => fun()
  }
}

///|
pub fn[A, B] Lazy::bind(self : Lazy[A], f : (A) -> Lazy[B]) -> Lazy[B] {
  match self.repr {
    Value(val) => f(val)
    Thunk(fun) => f(fun())
  }
}

///|
fn[A] Lazy::from_val(val : A) -> Lazy[A] {
  { repr: Value(val) }
}

///|
fn[A] Lazy::from_fun(fun : () -> A) -> Lazy[A] {
  { repr: Thunk(fun) }
}
