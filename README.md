# rational_number
[![Build Status](https://travis-ci.org/leifcr/rational_number.png?branch=devel)](https://travis-ci.org/leifcr/rational_number)

This implements basic rational numbers in Ruby. It can be used in tree implementations and provides a really fast way of looking up a sorted tree.

Read about rational numbers in tree structures here: http://arxiv.org/pdf/0806.3115v1.pdf

Note: This is NOT a tree implementation, it is only a wrapper of rational numbers in ruby.

For a proper tree implementation see e.g. [mm-tree](https://github.com/leifcr/mm-tree)

## Installation

### Using bundler

Latest stable release:

```ruby
gem 'rational_number'
```

For latest edge version:

```ruby
gem 'rational_number', :git => 'https://github.com/leifcr/rational_number.git'
```

This gem *only* supports the following versions:

   * mongomapper >= 0.13
   * ruby >= 2.0
   * rails >= 3.2

_Note: If you are using mongo\_mapper < 0.13, ruby < 2.0 or rails < 3.2 you have to use version 0.1.4.

### Without bundler

gem install rational_number

## Usage

```ruby
a = RationalNumber.new # Root
b = a.child_from_position(1) # Get child of root in position 1
b.next_sibling # Get next sibling of b
b.sibling_from_position(5) #Get sibling in position 5 on the current "level"

# More advanced
b.rational_number_from_ancestor_and_position(b,5) # Get a specific rational number from a given ancestor and position

# check if rational numbers are related
a.has_child?(b) # true
b.is_child_of?(root) # true

b.has_ancestor?(a) # true
a.is_ancestor_of?(b) # true
```

For more examples see the spec in spec/rational\_number\_spec.rb

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Send me a pull request, if you have features you like to see implemented.

## Thanks

_Dan Hazel_: For his paper on rational numbers

## Copyright

Original ideas are Copyright Jakob Vidmar and Joel Junström. Please see their github repositories for details
Copyright (c) 2013 Leif Ringstad.
See LICENSE for details.
