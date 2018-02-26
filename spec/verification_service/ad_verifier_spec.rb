require 'spec_helper'

describe AdVerifier do
  let(:verification_response) { described_class.new(campaigns, ads).call }

  context 'discrepancies' do
    let(:discrepancies) { verification_response.fetch(:discrepancies) }
    let(:discrepancy)   { discrepancies.find { |d| d.fetch(:campaign_id) == campaigns.first.id } }

    context 'status' do
      let(:status_discrepancy) { discrepancy.fetch(:discrepancies).find { |d| d[:status] } }

      let(:campaigns) do
        [
          Campaign.new(id: '1', job_id: '1', status: campaign_status, external_reference: '1', ad_description: 'Description for campaign 11')
        ]
      end

      let(:ads) do
        [
          Ad.new('reference' => '1', 'status' => ad_status, 'description' => 'Description for campaign 11')
        ]
      end

      context 'active' do
        let(:campaign_status) { 'active' }

        context 'irrelevant status' do
          let(:ad_status) { 'disabled' }

          it 'adds status discrepancy' do
            expect(status_discrepancy.fetch(:status).fetch(:campaign_status)).to eq campaign_status
            expect(status_discrepancy.fetch(:status).fetch(:ad_status)).to eq ad_status
          end
        end

        context 'relevant status' do
          let(:ad_status) { 'enabled' }

          it 'add no status discrepancy' do
            expect(status_discrepancy).to be_nil
          end
        end
      end

      context 'paused' do
        let(:campaign_status) { 'paused' }

        context 'irrelevant status' do
          let(:ad_status) { 'enabled' }

          it 'adds status discrepancy' do
            expect(status_discrepancy.fetch(:status).fetch(:campaign_status)).to eq campaign_status
            expect(status_discrepancy.fetch(:status).fetch(:ad_status)).to eq ad_status
          end
        end

        context 'relevant status' do
          let(:ad_status) { 'disabled' }

          it 'adds no status discrepancy' do
            expect(status_discrepancy).to be_nil
          end
        end
      end

      context 'deleted' do
        let(:campaign_status) { 'deleted' }

        context 'irrelevant status' do
          let(:ad_status) { 'enabled' }

          it 'adds status discrepancy' do
            expect(status_discrepancy.fetch(:status).fetch(:campaign_status)).to eq campaign_status
            expect(status_discrepancy.fetch(:status).fetch(:ad_status)).to eq ad_status
          end
        end

        context 'relevant status' do
          let(:ad_status) { 'disabled' }

          it 'adds no status discrepancy' do
            expect(status_discrepancy).to be_nil
          end
        end
      end
    end

    context 'description' do
      let(:description_discrepancy) { discrepancy.fetch(:discrepancies).find { |d| d[:description] } }

      let(:campaigns) do
        [
          Campaign.new(id: '1', job_id: '1', status: 'active', external_reference: '1', ad_description: campaign_description)
        ]
      end

      let(:ads) do
        [
          Ad.new('reference' => '1', 'status' => 'enabled', 'description' => ad_description)
        ]
      end

      context 'different' do
        let(:campaign_description) { 'Description for campaign 11' }
        let(:ad_description)       { 'Description for campaign 12' }

        it 'adds description discrepancy' do
          expect(description_discrepancy.fetch(:description).fetch(:campaign_description)).to eq campaign_description
          expect(description_discrepancy.fetch(:description).fetch(:ad_description)).to eq ad_description
        end
      end

      context 'same' do
        let(:campaign_description) { 'Description for campaign 11' }
        let(:ad_description)       { 'Description for campaign 11' }

        it 'add no description discrepancy' do
          expect(description_discrepancy).to be_nil
        end
      end
    end
  end

  context 'campaign without ad' do
    let(:campaigns) do
      [
        Campaign.new(id: '1', job_id: '1', status: 'active', external_reference: '1', ad_description: 'Description for campaign 11'),
        Campaign.new(id: '2', job_id: '2', status: 'paused', external_reference: '2', ad_description: 'Description for campaign 12')
      ]
    end

    let(:ads) { [] }

    it 'adds such campaigns to campaigns_without_ads' do
      expect(verification_response.fetch(:campaigns_without_ads)).to match_array [
        { id: '1', job_id: '1', status: 'active', external_reference: '1', ad_description: 'Description for campaign 11' },
        { id: '2', job_id: '2', status: 'paused', external_reference: '2', ad_description: 'Description for campaign 12' }
      ]
    end
  end

  context 'ad without campaign' do
    let(:campaigns) { [] }

    let(:ads) do
      [
        Ad.new('reference' => '1', 'status' => 'enabled',  'description' => 'Description for campaign 11'),
        Ad.new('reference' => '2', 'status' => 'disabled', 'description' => 'Description for campaign 12')
      ]
    end

    it 'adds such ads to ads_without_campaings' do
      expect(verification_response.fetch(:ads_without_campaings)).to match_array [
        { reference: '1', status: 'enabled',  description: 'Description for campaign 11' },
        { reference: '2', status: 'disabled', description: 'Description for campaign 12' }
      ]
    end
  end
end
