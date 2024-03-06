import «Leandate».Units.Day
import «Leandate».Units.Month
import «Leandate».Units.Year

namespace Leandate

structure Date where
  day : Day
  month : Month
  year : Year
  isValid : Prop := match month with
    | Month.january => day ≤ 31
    | Month.february => match year.leap with
      | true => day ≤ 29
      | false => day ≤ 28
    | Month.march => day ≤ 31
    | Month.april => day ≤ 30
    | Month.may => day ≤ 31
    | Month.june => day ≤ 30
    | Month.july => day ≤ 31
    | Month.august => day ≤ 31
    | Month.september => day ≤ 30
    | Month.october => day ≤ 31
    | Month.november => day ≤ 30
    | Month.december => day ≤ 31

def Date.toInt (d : Date) : Int :=
  365 * d.year.nonLeapYears + 366 * d.year.leapYears + d.day + (d.month.daysPassed d.year.leap)

/--
Convert an integer to a date. The integer is the number of days since 1 January 0.
-/
def Date.fromInt (n : Int) : Date := Id.run do
  let mut n := n
  let mut year : Year := 0
  let mut month := Month.january
  let mut day := 0
  while n < 0 do
    if n < 0 then
      year := year - 1
      n := n + if year.leap then 366 else 365
  while n > 365 do
    if n > 365 then
      year := year + 1
      n := n - if year.leap then 366 else 365
  while n > month.succ.daysPassed year.leap do
    month := month.succ
    if month = Month.december then
      break
  n := n - month.daysPassed year.leap
  day := n.toNat
  pure { day := day, month := month, year := year }

instance : ToString Date where
  toString d := s!"{d.day} {d.month} {d.year}"

#eval toString ( { day := 31, month := Month.december, year := 2020, isValid := true } : Date )

instance : Repr Date where
  reprPrec d _ := toString d

instance : Coe Date (Day × Month × Year) where
  coe d := (d.day, d.month, d.year)

instance : HAdd Date Day Date where
  hAdd d n := Date.fromInt (d.toInt + n)

instance : HSub Date Day Date where
  hSub d n := Date.fromInt (d.toInt - n)

instance : HAdd Date Month Date where
  hAdd d n := Date.fromInt (d.toInt + n.daysPassed d.year.leap)

instance : HSub Date Month Date where
  hSub d n := Date.fromInt (d.toInt - n.daysPassed d.year.leap)

-- #eval ( { day := 31, month := Month.december, year := 2020, isValid := true } : Date ) + 1

-- #eval Date.fromInt 335
-- #eval Date.fromInt 365

end Leandate
