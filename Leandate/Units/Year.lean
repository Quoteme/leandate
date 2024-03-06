namespace Leandate

abbrev Year : Type := Int

def Year.leap : Year → Bool := λ y ↦
  (y % 4 = 0) && (y % 100 ≠ 0) || (y % 400 = 0)

/--
Get the number of leap years between 0 and the given year.
-/
def Year.leapYears : Year → Nat := λ y ↦
  let y' : Nat := y.toNat
  (y' / 4) - (y' / 100) + (y' / 400)

/--
Get the number of non-leap years between 0 and the given year.
-/
def Year.nonLeapYears : Year → Nat := λ y ↦
  let y' : Nat := y.toNat
  y' - y.leapYears

#eval (2000 : Year).leap -- true
#eval (2001 : Year).leap -- false
#eval (2002 : Year).leap -- false
#eval (2003 : Year).leap -- false
#eval (2004 : Year).leap -- true

end Leandate
