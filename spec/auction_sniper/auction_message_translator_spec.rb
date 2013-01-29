require 'spec_helper'

class AuctionSniper
  describe AuctionMessageTranslator do
    subject(:translator) { AuctionMessageTranslator.new(listener) }
    let(:listener) { fake }
    let(:unused_chat) { fake }
    let(:message) { fake(body:"SOLVersion: 1.1; Event: CLOSE;") }

    context "notifies auction closed when close message received" do
      before { translator.process_message(unused_chat, message) }

      it "notifies auction closed when close message received" do
        listener.should have_received(:auction_closed)
      end
    end

    context "notifies bid details when current price message recieved" do
      let(:message) { fake(body:"SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7; Bidder: Someone else;") }
      before { translator.process_message(unused_chat, message) }

      it "notifies auction closed when close message received" do
        listener.should have_received(:current_price, 192, 7)
      end
    end
  end
end
