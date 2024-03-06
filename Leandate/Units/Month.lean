namespace Leandate

inductive Month : Type where
  | january : Month
  | february : Month
  | march : Month
  | april : Month
  | may : Month
  | june : Month
  | july : Month
  | august : Month
  | september : Month
  | october : Month
  | november : Month
  | december : Month
deriving instance DecidableEq for Month

instance : ToString Month where
  toString m := match m with
    | Month.january => "January"
    | Month.february => "February"
    | Month.march => "March"
    | Month.april => "April"
    | Month.may => "May"
    | Month.june => "June"
    | Month.july => "July"
    | Month.august => "August"
    | Month.september => "September"
    | Month.october => "October"
    | Month.november => "November"
    | Month.december => "December"

instance : Repr Month where
  reprPrec m _ := toString m

instance : Coe Month (Fin 12) where
  coe m := match m with
    | Month.january => 0
    | Month.february => 1
    | Month.march => 2
    | Month.april => 3
    | Month.may => 4
    | Month.june => 5
    | Month.july => 6
    | Month.august => 7
    | Month.september => 8
    | Month.october => 9
    | Month.november => 10
    | Month.december => 11

def Month.toFin12 (m : Month) : Fin 12 := m

instance : Coe Month Nat where
  coe m := ↑(m : Fin 12)

def Month.toNat (m : Month) : Nat := m

instance : Coe (Fin 12) Month where
  coe n := match n with
    | 0 => Month.january
    | 1 => Month.february
    | 2 => Month.march
    | 3 => Month.april
    | 4 => Month.may
    | 5 => Month.june
    | 6 => Month.july
    | 7 => Month.august
    | 8 => Month.september
    | 9 => Month.october
    | 10 => Month.november
    | 11 => Month.december

instance Month.fromFin12 : Coe (Fin 12) Month where
  coe n := n

/--
Get the next month given a month.
-/
def Month.succ (m : Month) : Month := (m : Fin 12).add 1

/--
Convert a number between 0 and 11 to a month and return none 12 or greater.
-/
instance : Coe Nat ( Option Month ) where
  coe n := if n > 0 && n ≤ 12 then
      let n' : Fin 12 := ⟨n, by sorry⟩
      some n'
    else
      none

def Month.fromNat (n : Nat) : Option Month := n

def Month.daysInMonth (m : Month) (isLeapYear : Bool) : Nat := match m with
  | Month.january => 31
  | Month.february => if isLeapYear then 29 else 28
  | Month.march => 31
  | Month.april => 30
  | Month.may => 31
  | Month.june => 30
  | Month.july => 31
  | Month.august => 31
  | Month.september => 30
  | Month.october => 31
  | Month.november => 30
  | Month.december => 31

/--
Given a month, returns the number of days that must have already passed in the year until the first of that month.
-/
def Month.daysPassed (m : Month) (isLeapYear : Bool) : Nat :=
  Nat.fold (λ n acc ↦ acc + ( (((n + 1) : Nat) : Option Month) <&> ( λ x ↦ x.daysInMonth isLeapYear ) ).getD 0) m 0

#eval Month.january.daysPassed false
#eval Month.february.daysPassed false
#eval Month.march.daysPassed false
#eval Month.april.daysPassed false
#eval Month.may.daysPassed false
#eval Month.june.daysPassed false
#eval Month.july.daysPassed false
#eval Month.august.daysPassed false
#eval Month.september.daysPassed false
#eval Month.october.daysPassed false
#eval Month.november.daysPassed false
#eval Month.december.daysPassed false

end Leandate
