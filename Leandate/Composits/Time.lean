import «Leandate».Units.Second
import «Leandate».Units.Minute
import «Leandate».Units.Hour

namespace Leandate

structure Time where
  second : Second
  minute : Minute
  hour : Hour

instance : ToString Time where
  toString t := s!"{t.hour}:{t.minute}:{t.second}"

instance : Repr Time where
  reprPrec t _ := toString t

instance : Coe Time (Hour × Minute × Second) where
  coe t := (t.hour, t.minute, t.second)

/--
The timestamp of a `Time` struct is the number of seconds since midnight.
-/
def Time.toTimestamp (t : Time) : Nat := t.hour*24*60 + t.minute*60+ t.second

/--
Construct a `Time` struct from a timestamp (the number of seconds since midnight).
-/
def Time.fromTimestamp (n : Nat) : Time := {
  second := Second.ofNat n,
  minute := Minute.ofNat n,
  hour := Hour.ofNat n
}

def Time.add (t1 t2 : Time) : Time := Time.fromTimestamp (t1.toTimestamp + t2.toTimestamp)

instance : Add Time where
  add := Time.add

def Time.sub (t1 t2 : Time) : Time := Time.fromTimestamp (t1.toTimestamp - t2.toTimestamp)

instance : Sub Time where
  sub := Time.sub

/--
Get the current number of seconds since midnight.
-/
def Time.currentTimestamp : IO Nat := do
  let system ← IO.getEnv "OS"
  if system == "Windows_NT" then
    -- TODO: implement this for Windows
    return 0
  else
    let numberOfSecondsSinceMidnight ← String.trim <$> IO.Process.run { cmd := "bash", args := #["-c", "echo $(($(date +%s) - $(date -d \"today 00:00\" +%s)))"] }
    let n := String.toNat! numberOfSecondsSinceMidnight
    return n

/--
Get the current time.
-/
def Time.now : IO Time := do
  let n ← Time.currentTimestamp
  return Time.fromTimestamp n

#eval Time.now

end Leandate
