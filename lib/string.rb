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

    # Create an addition object if the top level is an addition
    unless terms.length == 1
      terms.map!{|term| term.objectify}
      return Addition.new(terms)
    end

    # Match all bracketed terms: \((?>[^)(]+|\g<0>)*\)
    # Match all curly-bracketed terms: \{(?>[^}{]+|\g<0>)*\} needs work before frac becomes useful
  end
end
