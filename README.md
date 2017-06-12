# Objectify Tech Test

### Description
In order to make your team more efficient in writing well-tested code, you have been tasked to develop an **extremely important** utility that converts a string which is the LaTeX syntax for a mathematical expression into the relevant Ruby objects.  It is estimated this utility method improves overall code writing productivity by 5-10%!

### Task
Extend `String class` with a function called `objectify` which converts a Latex string such as `'\frac{2x+3}{x-4}'` into our corresponding Ruby objects.  For example, calling `objectify` on the string `"2+3"` should return an instance of `Addition`, with arguments of 2 and 3.  That is `"2+3".objectify` should return `Addition.new(2,3)`.

### Examples
```ruby
# Addition :add
'-2+3'.objectify
=> Addition.new(-2, 3)

# Multiplication :mtp
'2xy'.objectify
=> Multiplication.new(2, 'x', 'y')

# Division :div
'\frac{-2}{3}'.objectify
=> Division.new(-2, 3)

'\frac{-14x}{25}'.objectify
=> div(mtp(-14, 'x'), 25)  #factory methods see notes
```
> For more examples please refer to the spec file `spec/lib/string_spec.rb`

### Notes
* Review the models for basic `Addition`, `Multiplication` objects in the lib folder.
* Arguments in general can be input in two ways:  as an `Array` of arguments e.g. `Addition.new([2,3,4])`, or as individual arguments e.g. `Addition.new(2,3,4)`.
* `Division` takes two arguments, you can make use the alias setter and getter methods for numerator / top and denominator / bot.
*  **You should make use of our basic factories**.  For example `add(2,3)` is the same as `Addition.new(2,3)`.


### Requirements
* Make all the tests pass.
* Your code should be _general_ enough to handle any level of recursion!
* We will put your code through additional tests once we received it.

### Getting Started
* Install ruby 2.3.1+
* From the project directory run `bundle install`
* Check the test spec in `./spec/string_spec.rb`
* Write your code in `./lib/string.rb`
* Run `rspec` from the project directory to check your progress.
* Run `rspec ./spec/lib/string_spec.rb:4` to run only the test starting on line 4.

### Hints
* You are not limited to having only a single function, should you see it appropriate you can add more supporting functions.</br>
* The task can be completed without the use of regular expressions, however, it is **highly recommended** that you make use of regular expressions.
