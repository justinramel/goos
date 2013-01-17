require 'spec_helper'

describe AuctionSniper do
  let(:auction) { FakeAuctionServer.new('item-54321') }
  let(:application) { ApplicationRunner.new }

  it "sniper joins auction until auction closes" do
    auction.start_selling_item
    application.start_bidding_in(auction)
    auction.has_received_join_request_from_sniper
    auction.announce_closed
    application.shows_sniper_has_lost_auction
  end

  after { auction.stop }
  after { application.stop }
end
