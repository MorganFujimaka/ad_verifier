class AdFetcher
  URL = 'http://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'

  attr_reader :response

  def self.call
    new.call
  end

  def call
    request_ads
    parse_response
  end

  private

  def request_ads
    @response = ::HTTParty.get(URL)
  rescue => e
    raise_error(e.message)
  end

  def parse_response
    raise_error(response.message) unless response.success?

    JSON.parse(response).fetch('ads').map { |r| Ad.new(r) }
  end

  def raise_error(message)
    raise VerificationService::AdFetcherError, message
  end
end
