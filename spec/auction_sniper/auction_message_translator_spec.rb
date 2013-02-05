require 'spec_helper'

class AuctionSniper
  describe AuctionMessageTranslator do
    subject(:translator) { AuctionMessageTranslator.new(sniper_id, listener) }
    let(:listener) { fake }
    let(:unused_chat) { fake }
    let(:message) { fake(body:"SOLVersion: 1.1; Event: CLOSE;") }
    let(:sniper_id) { 'sniper' }

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

    context 'when current price message is from an other bidder' do
      let(:message) { fake(body:"SOLVersion: 1.1; Event: PRICE; CurrentPrice: 234; Increment: 5; Bidder: #{bidder_id};") }
      let(:bidder_id) { 'Someone else' }
      before { translator.process_message(unused_chat, message) }

      it 'notifies that the bid came from another bidder' do
        listener.should have_received(:current_price, 234, 5, :from_other_bidder)
        translator.process_message(unused_chat, message)
      end
    end

  end
end
