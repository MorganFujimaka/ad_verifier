class Ad
  attr_reader :reference, :status, :description

  def initialize(attrs)
    @reference   = attrs.fetch('reference')
    @status      = attrs.fetch('status')
    @description = attrs.fetch('description')
  end

  def to_h
    {
      reference:   reference,
      status:      status,
      description: description
    }
  end
end
