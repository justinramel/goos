class XMPPAuction
  def initialize(chat)
    @chat = chat
  end

  def bid(amount)
    send_message(AuctionSniper::Main::BID_COMMAND_FORMAT % amount)
  end

  def join
    send_message(AuctionSniper::Main::JOIN_COMMAND_FORMAT)
  end

  private
  def send_message(message)
    @chat.send_message(message)
  rescue XMPPException => e
    puts e.message
  end

end
