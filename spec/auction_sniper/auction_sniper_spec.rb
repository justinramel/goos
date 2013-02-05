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

    before { sniper.current_price(price, increment, :from_other_bidder) }

    it "reports bidding when new price arrives" do
      auction.should have_received(:bid, price + increment).once
      sniper_listener.should have_received(:sniper_bidding).at_least_once
    end
  end

  context "reports is winning" do
    let(:price) { 123 }
    let(:increment) { 45 }
    before { sniper.current_price(price, increment, :from_sniper) }

    it "current price comes from sniper" do
      sniper_listener.should have_received(:sniper_winning).at_least_once
    end
  end

  context "reports won" do
    let(:price) { 123 }
    let(:increment) { 45 }
    before { sniper.current_price(price, increment, :from_sniper) }
    before { sniper.auction_closed }

    it "has winning bid when auction closes" do
      sniper_listener.should have_received(:sniper_won).at_least_once
    end
  end
end
