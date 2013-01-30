class AuctionSniper
  def initialize(auction, listener)
    @auction  = auction
    @listener = listener
  end

  def auction_closed
    @listener.sniper_lost
  end

  def current_price(price, increment)
    @auction.bid(price + increment)
    @listener.sniper_bidding
  end

  def self.start(hostname, sniper_id, password, item_id)
    main = Main.new
    main.start_user_interface
    connection = connection(hostname, sniper_id, password)
    main.disconnect_when_ui_closes(connection)
    main.join_auction(connection, item_id)
  end

  def self.connection(hostname, username, password)
    connection = Smack::XMPPConnection.new(hostname)
    connection.connect
    connection.login(username, password, FakeAuctionServer::AUCTION_RESOURCE)
    connection
  end
end
