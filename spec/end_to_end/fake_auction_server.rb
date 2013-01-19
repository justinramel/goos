class FakeAuctionServer
  ITEM_ID_AS_LOGIN = 'auction-%s'
  AUCTION_RESOURCE = 'Auction'
  XMPP_HOSTNAME = 'localhost'
  AUCTION_PASSWORD = 'auction'

  attr_reader :item_id, :current_chat

  def initialize(item_id)
    @item_id = item_id
    @connection = Smack::XMPPConnection.new(XMPP_HOSTNAME)
    @message_listener = SingleMessageListener.new
  end

  def start_selling_item
    @connection.connect
    @connection.login(ITEM_ID_AS_LOGIN % @item_id,
                      AUCTION_PASSWORD,
                      AUCTION_RESOURCE)
    @connection.get_chat_manager.add_chat_listener do |chat, created_locally|
      @current_chat = chat
      chat.add_message_listener(@message_listener)
    end
  end

  def has_received_join_request_from_sniper
    @message_listener.receives_a_message
  end

  def announce_closed
    current_chat.send_message(Smack::Message.new)
  end

  def stop
    @connection.disconnect
  end

end
