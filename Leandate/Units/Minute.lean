namespace Leandate

abbrev Minute : Type := Fin 60

def Minute.ofNat (n : Nat) : Minute := Fin.ofNat' (n / 60) (by decide)

end Leandate
