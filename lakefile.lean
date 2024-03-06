import Lake
open Lake DSL

package «leandate» where
  -- add package configuration options here

require std from git "https://github.com/leanprover/std4" @ "v4.6.1"

@[default_target]
lean_lib «Leandate» where
  -- add library configuration options here
