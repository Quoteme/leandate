import «Leandate».Units.Day
import «Leandate».Units.Month
import «Leandate».Units.Year

namespace Leandate

structure Date where
  day : Day
  month : Month
  year : Year
  isValid : match month with
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
Convert an integer `n` to a date.
`n` is the number of days since 1 January 0.
-/
def Date.fromInt (n : Int) : Date := Id.run do
  let mut n := n
  let mut year : Year := 0
  let mut month := Month.january
  let mut day := 0
  -- 1. calculate how many years have passed
  -- 1.1. if `n` is negative, we subtract years until `n` is positive
  while n < 0 do
    if n < 0 then
      year := year - 1
      n := n + if year.leap then 366 else 365
  -- 1.2. decrease `n` by one years worth of days, until it is less than a year
  while n > 365 do
    if n > 365 then
      year := year + 1
      n := n - if year.leap then 366 else 365
  -- 2. calculate how many months have passed
  while n > month.succ.daysPassed year.leap do
    month := month.succ
    if month = Month.december then
      break
  n := n - month.daysPassed year.leap
  day := n.toNat
  pure {
    day := day,
    month := month,
    year := year,
    isValid := by
      -- TODO: finish this proof
      match month with
      | Month.january => {
        simp
        cases Year.leap year with
        | true => sorry
        | false => sorry
      }
      | Month.february => sorry
      | _ => sorry
  }

instance : ToString Date where
  toString d := s!"{d.day} {d.month} {d.year}"

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

instance : HAdd Date Year Date where
  hAdd d y := {
    day := d.day,
    month := d.month,
    year := d.year + y,
    isValid := sorry
  };

instance : HSub Date Year Date where
  hSub d y := {
    day := d.day,
    month := d.month,
    year := d.year - y,
    isValid := sorry
  };

-- #eval ({year := 2000, day := 4, month := Month.april, isValid := sorry} : Date) - (10 : Year)
-- #eval Date.fromInt 335
-- #eval Date.fromInt 365

/--
Get the current number of days since 1 January 0.
-/
def Date.currentDaysPassed : IO Int := do
  let system ← IO.getEnv "OS"
  if system == "Windows_NT" then
    -- TODO: implement this for Windows
    return 0
  else
    -- 1. get the number of days since 1 January 0000
    let cmd ← String.trim <$> IO.Process.run {
      cmd := "bash",
      args := #["-c", "echo $(( ($(date +%s) / 86400) + 719528 )) "]
    }
    -- 2. because we start counting from 0 January 0000, we need to add a day
    return ( cmd.toNat! + 1)

/--
Get the current date.
-/
def Date.now : IO Date := do
  let n ← Date.currentDaysPassed
  return Date.fromInt n

end Leandate
