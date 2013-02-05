require 'spec_helper'

describe AuctionSniper do
  let(:auction) { FakeAuctionServer.new('item-54321') }
  let(:application) { ApplicationRunner.new }

  it "sniper joins auction until auction closes" do
    auction.start_selling_item
    application.start_bidding_in(auction)
    auction.has_received_join_request_from(ApplicationRunner::SNIPER_XMPP_ID)
    auction.announce_closed
    application.shows_sniper_has_lost_auction
  end

  it "sniper makes a higher bid but loses" do
    auction.start_selling_item
    application.start_bidding_in(auction)
    auction.has_received_join_request_from(ApplicationRunner::SNIPER_XMPP_ID)
    auction.report_price(1000, 98, "other bidder")
    application.has_shown_sniper_is_bidding
    auction.has_received_bid(1098, ApplicationRunner::SNIPER_XMPP_ID)
    auction.announce_closed
    application.shows_sniper_has_lost_auction
  end

  it "sniper winds an auction by bidding higher" do
    auction.start_selling_item
    application.start_bidding_in(auction)
    auction.has_received_join_request_from(ApplicationRunner::SNIPER_XMPP_ID)
    auction.report_price(1000, 98, "other bidder")
    application.has_shown_sniper_is_bidding
    auction.has_received_bid(1098, ApplicationRunner::SNIPER_XMPP_ID)

    auction.report_price(1098, 97, ApplicationRunner::SNIPER_XMPP_ID)
    application.has_shown_sniper_is_winning

    auction.announce_closed
    application.shows_sniper_has_won_auction
  end

  after { auction.stop }
  after { application.stop }
end
