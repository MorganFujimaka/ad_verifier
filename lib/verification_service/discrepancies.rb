require_relative 'discrepancies/status'
require_relative 'discrepancies/description'

module Discrepancies
  extend self

  DISCREPANCIES = [
    Status,
    Description
  ]

  def call(campaign, ad)
    DISCREPANCIES.map { |d| d.call(campaign, ad) }.compact
  end
end
