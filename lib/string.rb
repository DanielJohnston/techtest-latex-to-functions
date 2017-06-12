class String
  def objectify
    # Addition match and translate
    add_matcher = /\A(-?[0-9a-z]+)\+([0-9a-z]+)\z/
    unless self[add_matcher, 0].nil?
      left_side = self[add_matcher, 1].to_apropos
      right_side = self[add_matcher, 2].to_apropos
      return Addition.new(left_side, right_side)
    end
  end

  def to_apropos
    puts self
    return self.to_s.to_i if self.to_s == self.to_s.to_i.to_s
    return self.to_s.to_f if self.to_s.to_f == self.to_s.to_f.to_s
    self
  end
end
