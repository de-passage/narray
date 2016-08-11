# narray
A n-dimensional storage structure for Ruby

Manipulating nested arrays in Ruby is a pain and there doesn't seem to be any general purpose solutions (i.e. not math-oriented) available so here is a shot at it.

# Purpose 
The idea spawned from trying to map the area around a character in [rubywarrior](https://github.com/ryanb/ruby-warrior/ "Ruby Warrior") without making any assumption about the size of the map. 
In other words I needed a 2D array that could grow in any direction. A NArray is a generalization of this idea for an arbitrary number of dimensions. It is similar to a regular array, except you deal with sets of data rather than individual values. E.g. in a 2-dimensional array (a table), you would add and remove rows and columns. 
The class is a child of Array and responds to #to_ary if one needs to fall back to classic array behaviour (atm work needs to be done to provide a sensible replacement for Enumerator).


# Documentation 
Incoming

Tested with minitest 5.9.0
