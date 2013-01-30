require 'spec_helper'

describe AuctionSniper do
  subject(:sniper) { AuctionSniper.new(auction, sniper_listener) }
  let(:auction) { fake }
  let(:sniper_listener) { fake }

  context "reports lost when auction closes" do
    before { sniper.auction_closed }

    it "reports lost when auction closes" do
      sniper_listener.should have_received(:sniper_lost)
    end
  end

  context "bids higher" do
    let(:price) { 1001 }
    let(:increment) { 25 }

    before { sniper.current_price(price, increment) }

    it "reports bidding when new price arrives" do
      auction.should have_received(:bid, price + increment).once
      sniper_listener.should have_received(:sniper_bidding).at_least_once
    end
  end
end
