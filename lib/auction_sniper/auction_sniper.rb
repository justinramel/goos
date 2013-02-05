class AuctionSniper
  def initialize(auction, listener)
    @auction    = auction
    @listener   = listener
    @is_winning = false
  end

  def auction_closed
    @is_winning ? @listener.sniper_won : @listener.sniper_lost
  end

  def current_price(price, increment, price_source)
    @is_winning = price_source == :from_sniper
    if @is_winning
      @listener.sniper_winning
    else
      @auction.bid(price + increment)
      @listener.sniper_bidding
    end
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
