class String
  Bracket_matcher = '\((?>[^)(]+|\g<0>)*\)'
  Curly_matcher = '\{(?>[^}{]+|\g<0>)*\}'
  Alphanumeric_matcher = '[a-z]|[0-9]+'
  # Frac_matcher = '\\frac'

  def objectify
    # self is the current fragment of LaTeX

    ##### CLEAN UP #####

    # Remove all whitespace before doing anything else
    self.gsub!(/\s/,'')
    # Remove '+' from beginning before adding again later
    self.slice!(/\A\+/)
    # Remove brackets if they enclose everything, including curly brackets
    self.chop!.slice!(0) if self == self[/#{Bracket_matcher}/] || self == self[/#{Curly_matcher}/]

    ##### INDIVIDUAL FACTORS #####

    # Return an integer if the string is just an integer; can be -ve
    value = Integer(self) rescue false
    return value if value

    # Return a variable if the string is just an (unsigned) variable
    char = self[/\A[\+]?([a-z])\z/,1]
    return char if char

    # Spot and handle a top-level fraction
    if self == self.read_fraction.to_s
      operands = self.scan(/#{Curly_matcher}/)
      operands.map!{ |operand| recurse_factor(operand) }
      return div(operands)
    end

    # Ensure a sign at the beginning to regularise sign handling for terms
    self.prepend('+') unless self[0][/\A[\+|\-]/]

    # Best approach is to find the top-level operation and terms, then
    # to objectify each of the terms in turn via recursion

    # no. of terms in top level can be >= 2, each with same operation
    # Split the expression into terms and factors, with a sign preceding each term
    terms = self.split_terms

    ###### ADDITION HANDLING #####

    # Create an addition object if the top level has addition operations
    unless terms.length == 1
      terms.map!{ |term| recurse_factor(term.join) }
      return add(terms)
    end

    # There's only one term after this point, so change language to reflect that
    factors = terms.first

    ##### MULTIPLICATION HANDLING #####

    unless factors.length == 2 && factors.first == '+'
      # Negative sign either becomes a factor of -1, or adds sign to first factor integer
      if factors[0] == '-'
        if factors[1][/\A[0-9]+\z/]
          factors[1].prepend(factors.shift)
        else
          factors[0] = '-1'
        end
      else
        factors.shift
      end
      # Create a multiplication object
      factors.map!{ |factor| recurse_factor(factor) }
      return mtp(factors)
    end

    # Pass through objectification of the single factor in this case
    return recurse_factor(factors[1])

    # sign, term = terms[0][0], terms[0][1..-1]
    # factor_matcher = '[a-z]|[0-9]+'
    # factors = term.scan(/#{factor_matcher}/)


    # Return a multiplication object if the top level has multiple factors
    # unless factors.length == 1
    #   factors.map!{ |factor| factor.objectify }
    #   return Multiplication.new(factors)
    # end
    raise "Couldn't handle term: #{term}"
  end

  def split_terms
    # Desired output is array of terms as strings, with sign as first char
    terms = []
    term_in_progress = [self[0]]
    position = 1

    while position < self.length
      next_char = self[position]
      case next_char
      when '('
        # Bracketed section
        partial = self.match(/#{Bracket_matcher}/, position).to_s
        term_in_progress << partial
        position += partial.length
      when '\\'
        # Only \frac{}{} for now, which has 3 elements to match
        # No handling of malformed fractions at present, either
        partial = self[position..-1].read_fraction
        term_in_progress << partial
        position += partial.length
      when /[0-9a-z]/
        # Alphanumeric digits
        partial = self.match(/#{Alphanumeric_matcher}/, position).to_s
        term_in_progress << partial
        position += partial.length
      when "^"
        # Power operator; store base, power and exponent as a sub-array factor
        base = term_in_progress.pop
        position += 1
        if self[position] == "{"
          # Capture curly-bracketed section as exponent
          exponent = self.match(/#{Curly_matcher}/, position).to_s
          position += 1
        else
          exponent = self[position]
        end
        position += exponent.length
        term_in_progress << pow(recurse_factor(base), recurse_factor(exponent))
      # when '{'
      #   # Curly-bracketed section, to capture
      #   partial = self.match(/#{Curly_matcher}/, position).to_s
      #   term_in_progress << partial
      #   position += partial.length
      when /[+-]/
        # End of term
        terms << term_in_progress
        term_in_progress = [self[position]]
        position += 1
      else
        raise "Unrecognised operator: #{next_char}"
      end
    end
  terms << term_in_progress
  end

  def read_fraction
    frac_string = '\\frac' + self.scan(/#{Curly_matcher}/)[0..1].join
    return nil unless self[0..frac_string.length - 1] == frac_string
    frac_string
  end

  def recurse_factor factor
    if factor.is_a? String
      factor.objectify
    else
      factor
    end
    # factor.is_a? String ? factor.objectify : factor
  end
end
