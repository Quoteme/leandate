namespace Leandate

abbrev Year : Type := Int

def Year.leap : Year → Bool := λ y ↦
  (y % 4 = 0) && (y % 100 ≠ 0) || (y % 400 = 0)

#eval (2000 : Year).leap -- true
#eval (2001 : Year).leap -- false
#eval (2002 : Year).leap -- false
#eval (2003 : Year).leap -- false
#eval (2004 : Year).leap -- true

end Leandate
