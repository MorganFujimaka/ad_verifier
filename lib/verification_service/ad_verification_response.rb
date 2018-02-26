class AdVerificationResponse
  attr_reader :discrepancies, :campaigns_without_ads, :ads_without_campaings

  def initialize(discrepancies:, campaigns_without_ads:, ads_without_campaings:)
    @discrepancies         = discrepancies
    @campaigns_without_ads = campaigns_without_ads
    @ads_without_campaings = ads_without_campaings
  end
end
