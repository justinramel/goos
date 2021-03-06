class ApplicationRunner
  SNIPER_XMPP_ID  = 'sniper@localhost/Auction'
  XMPP_HOSTNAME   = 'localhost'
  SNIPER_ID       = 'sniper'
  SNIPER_PASSWORD = 'sniper'

  def start_bidding_in(auction)
    Thread.new("Test Application") do
      begin
        AuctionSniper.start(XMPP_HOSTNAME,
                            SNIPER_ID,
                            SNIPER_PASSWORD,
                            auction.item_id)
      rescue Exception => e
        puts e.message
        puts e.backtrace
      end
    end
    @driver = AuctionSniperDriver.with_timeout(1000)
    @driver.shows_sniper_status(AuctionSniper::MainWindow::STATUS_JOINING)
  end

  def shows_sniper_has_lost_auction
    @driver.shows_sniper_status(AuctionSniper::MainWindow::STATUS_LOST)
  end

  def shows_sniper_has_won_auction
    @driver.shows_sniper_status(AuctionSniper::MainWindow::STATUS_WON)
  end

  def has_shown_sniper_is_bidding
    @driver.shows_sniper_status(AuctionSniper::MainWindow::STATUS_BIDDING)
  end

  def has_shown_sniper_is_winning
    @driver.shows_sniper_status(AuctionSniper::MainWindow::STATUS_WINNING)
  end

  def stop
    @driver.dispose if @driver
  end

end
