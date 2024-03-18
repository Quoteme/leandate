import «Leandate».Composites.Date
import «Leandate».Composites.Time

namespace Leandate

structure DateTime where
  date : Date
  time : Time

instance : ToString DateTime where
  toString dt := s!"{dt.date} {dt.time}"

instance : Repr DateTime where
  reprPrec t _ := toString t

def DateTime.now : IO DateTime := do
  let date ← Date.now
  let time ← Time.now
  pure { date, time }

#eval DateTime.now

end Leandate
