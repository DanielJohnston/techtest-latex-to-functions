class String
  def objectify
    # self is the current fragment of LaTeX

    # Remove all whitespace before doing anything else
    self.gsub!(/\s/,'')

    # Return an integer if the string is just an integer; can be -ve
    value = Integer(self) rescue false
    return value if value

    # Return a variable if the string is just an (unsigned) variable
    char = self[/\A[\+]?([a-z])\z/,1]
    return char if char

    # Ensure a sign at the beginning to regularise sign handling for all terms
    self.prepend('+') unless self[0] == '-'

    # Best approach is to find the top-level operation and terms, then
    # to objectify each of the terms in turn via recursion
    # no. of terms in top level can be >= 2, each with same operation

    # Presume addition, and drop to other operations if there's only one term
    # At this stage, assume no tricky terms
    # Desired output is a list of terms as strings, with sign as first char
    term_matcher = '[\+|\-][0-9a-z]+'
    terms = self.scan(/#{term_matcher}/)

    # Create an addition object if the top level has addition operations
    unless terms.length == 1
      terms.map!{ |term| term.objectify }
      return Addition.new(terms)
    end

    # If the top level isn't addition, break into multiplication factors
    sign, term = terms[0][0], terms[0][1..-1]
    factor_matcher = '[a-z]|[0-9]+'
    factors = term.scan(/#{factor_matcher}/)

    # Move a negative sign into the factorisation, where e.g. -a => -1 x a
    if sign == '-'
      if factors[0][/[0-9]+/]
        factors[0] = '-' + factors[0]
      else
        factors.unshift('-1')
      end
    end

    # Return a multiplication object if the top level has multiple factors
    unless factors.length == 1
      factors.map!{ |factor| factor.objectify }
      return Multiplication.new(factors)
    end

    # Match all bracketed terms: \((?>[^)(]+|\g<0>)*\)
    # Match all curly-bracketed terms: \{(?>[^}{]+|\g<0>)*\} needs work before frac becomes useful
  end
end
