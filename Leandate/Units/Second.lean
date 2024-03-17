namespace Leandate

abbrev Second : Type := Fin 60

def Second.ofNat (n : Nat) : Second := Fin.ofNat' n (by decide)

end Leandate
