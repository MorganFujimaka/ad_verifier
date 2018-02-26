class Campaign
  attr_reader :id, :job_id, :external_reference, :status, :ad_description

  def initialize(attrs)
    @id                 = attrs.fetch(:id)
    @job_id             = attrs.fetch(:job_id)
    @external_reference = attrs.fetch(:external_reference)
    @status             = attrs.fetch(:status)
    @ad_description     = attrs.fetch(:ad_description)
  end

  def to_h
    {
      id:                 id,
      job_id:             job_id,
      external_reference: external_reference,
      status:             status,
      ad_description:     ad_description
    }
  end
end
