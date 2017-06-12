class Division < Expression
  def post_init(args)
    if self.args[2].nil?
      @args[2] = '+@'
    end

    if self.args[2].is_a?(Symbol)
      @args[2] = self.args[2].to_s + '@'
    end
  end

  def top
    args[0]
  end

  def bot
    args[1]
  end

  def top=(value)
    self.args[0] = value
  end

  def bot=(value)
    self.args[1] = value
  end

  alias_method :numerator, :top
  alias_method :denominator, :bot
end
