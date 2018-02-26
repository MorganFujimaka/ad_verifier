require_relative 'base'

module Discrepancies
  class Status < Base
    CAMPAIGN_TO_AD_STATUS_MAP = {
      active:  :enabled,
      paused:  :disabled,
      deleted: :disabled
    }.freeze

    def call
      if CAMPAIGN_TO_AD_STATUS_MAP.fetch(campaign_status.to_sym) != ad_status.to_sym
        {
          status: {
            campaign_status: campaign_status,
            ad_status: ad_status
          }
        }
      end
    end

    private

    def campaign_status
      campaign.status
    end

    def ad_status
      ad.status
    end
  end
end
