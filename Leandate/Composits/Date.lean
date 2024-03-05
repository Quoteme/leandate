import «Leandate».Units.Day
import «Leandate».Units.Month
import «Leandate».Units.Year

namespace Leandate

structure Date where
  day : Day
  month : Month
  year : Year
  valid : match month with
    | Month.january => day <= 31

end Leandate
