# Atomsk.jl Documentation

## About

Atomsk.jl is a julia wrapper around the Atomsk software developed by Pierre Hirel at the University of Lille, France. Atomsk is able to generate many different types of atomic configurations for use in simulations. Full documentation can be found [here](https://atomsk.univ-lille.fr/doc.php).

## Installation

Atomsk.jl is registered in the Julia general registry and can be installed by running in the REPL package manager (]):

```
add Atomsk
```

## API

There are two types of methods implemented from Atomsk, Modes and Options. Modes generally deal with the creation of atomic configurations, while Options modify an existing configuration.

### Modes

There are two modes available, `create` and `polycrystal`. 

```@docs
create
polycrystal
```

### Options

With the exception of `options` and `properties`, all of the Options listed in the Atomsk [documentation](https://atomsk.univ-lille.fr/doc.php) are implemented. These function names are the Option names without any dashes (e.g. `-add-atom` becomes `addatom(args...)`. Arguments can be passed in any form as they are converted to strings when passed to the Atomsk program. All arguments are stripped of strings and spaces. This allows Miller indices to be passed in as integer arrays (e.g. [1,1,1] becomes [111]).
