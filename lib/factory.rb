module Factory
  def add(*args)
    Addition.new(*args)
  end

  def sbt(*args)
    Subtraction.new(*args)
  end

  def mtp(*args)
    Multiplication.new(*args)
  end

  def div(*args)
    Division.new(*args)
  end

  def pow(*args)
    Power.new(*args)
  end
end
