require 'spec_helper'

describe VerificationService do
  describe '.call', vcr: true do
    let(:verification_response) { described_class.call(campaigns) }

    let(:campaigns) do
      [
        { id: '1', job_id: '1', status: 'active',  external_reference: '1', ad_description: 'Description for campaign 11' },
        { id: '2', job_id: '2', status: 'active',  external_reference: '2', ad_description: 'Description for campaign 22' },
        { id: '4', job_id: '4', status: 'deleted', external_reference: '4', ad_description: 'Description for campaign 14' }
      ]
    end

    it 'verifies campaigns and ads' do
      expect(verification_response.campaigns_without_ads).to match_array [
        { id: '4', job_id: '4', external_reference: '4', status: 'deleted', ad_description: 'Description for campaign 14' }
      ]

      expect(verification_response.ads_without_campaings).to match_array [
        { reference: '3', status: 'enabled', description: 'Description for campaign 13' }
      ]

      expect(verification_response.discrepancies).to match_array [
        {
          campaign_id:   '1',
          ad_reference:  '1',
          discrepancies: []
        },
        {
          campaign_id:  '2',
          ad_reference: '2',
          discrepancies: [
            {
              status: {
               campaign_status: 'active',
               ad_status:       'disabled'
              }
            },
            {
              description: {
                campaign_description: 'Description for campaign 22',
                ad_description:       'Description for campaign 12'
              }
            }
          ]
        }
      ]
    end
  end
end
