namespace Leandate

abbrev Hour : Type := Fin 24

def Hour.ofNat (n : Nat) : Hour := Fin.ofNat' (n / 60 / 60) (by decide)

end Leandate
