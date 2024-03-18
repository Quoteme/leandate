# Leandate

A simple library for [Lean4](https://lean-lang.org/) to work with dates and times.

## Installation

Add the following to your `lakefile.lean`:

```lean
require std from git "https://github.com/quoteme/leandate" @ "mastemaster
```

## Usage

```lean
import «Leandate».Composites.DateTime

#eval ( { day := 31, month := Month.december, year := 2020 } : Date ) + ( 1 : Day ) + (( 3 : Fin 12 ) : Month)

#eval DateTime.now -- 17 March 2024 12:34:47
```
