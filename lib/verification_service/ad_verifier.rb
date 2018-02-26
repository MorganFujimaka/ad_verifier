class AdVerifier
  attr_reader :campaigns, :ads

  def self.call(campaigns, ads)
    new(campaigns, ads).call
  end

  def initialize(campaigns, ads)
    @campaigns = campaigns
    @ads = ads
  end

  def call
    AdVerificationResponse.new(
      discrepancies:         discrepancies,
      campaigns_without_ads: campaigns_without_ads.map(&:to_h),
      ads_without_campaings: ads_without_campaings.map(&:to_h)
    )
  end

  private

  def discrepancies
    campaigns_with_ads.map do |c|
      ad = ads.find { |a| a.reference == c.external_reference }

      {
        campaign_id:   c.id,
        ad_reference:  ad.reference,
        discrepancies: Discrepancies.call(c, ad)
      }
    end
  end

  def campaigns_with_ads
    campaigns.select do |c|
      (campaign_external_references & ad_references).include?(c.external_reference)
    end
  end

  def campaigns_without_ads
    campaigns.select do |c|
      (campaign_external_references - ad_references).include?(c.external_reference)
    end
  end

  def ads_without_campaings
    ads.select do |a|
      (ad_references - campaign_external_references).include?(a.reference)
    end
  end

  def campaign_external_references
    @campaign_external_references ||= campaigns.map(&:external_reference)
  end

  def ad_references
    @ad_references ||= ads.map(&:reference)
  end
end
