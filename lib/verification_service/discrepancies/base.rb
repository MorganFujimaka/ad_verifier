module Discrepancies
  class Base
    attr_reader :campaign, :ad

    def self.call(campaign, ad)
      new(campaign, ad).call
    end

    def initialize(campaign, ad)
      @campaign = campaign
      @ad = ad
    end

    def call
      raise NotImplementedError
    end
  end
end
