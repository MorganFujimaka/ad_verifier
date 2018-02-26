require_relative 'base'

module Discrepancies
  class Description < Base
    def call
      if campaign_description != ad_description
        {
          description: {
            campaign_description: campaign_description,
            ad_description: ad_description
          }
        }
      end
    end

    private

    def campaign_description
      campaign.ad_description
    end

    def ad_description
      ad.description
    end
  end
end
