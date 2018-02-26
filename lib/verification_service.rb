require 'json'
require 'httparty'

require 'verification_service/exceptions'
require 'verification_service/ad_fetcher'
require 'verification_service/ad_verifier'
require 'verification_service/ad_verification_response'
require 'verification_service/campaign'
require 'verification_service/ad'
require 'verification_service/discrepancies'

module VerificationService
  def self.call(campaigns)
    ads = AdFetcher.call
    campaigns = campaigns.map { |c| Campaign.new(c) }

    AdVerifier.call(campaigns, ads)
  end
end
