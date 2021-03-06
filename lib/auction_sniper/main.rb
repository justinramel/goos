class AuctionSniper
  class Main
    AUCTION_RESOURCE = 'Auction'
    ITEM_ID_AS_LOGIN = 'auction-%s'
    AUCTION_ID_FORMAT = ITEM_ID_AS_LOGIN + '@%s/' + AUCTION_RESOURCE
    JOIN_COMMAND_FORMAT = "SOL: 1.1; Command: Join;"
    BID_COMMAND_FORMAT = 'SOLVersion: 1.1; Command: Bid; Amount: %d'

    def start_user_interface
      Swing::SwingUtilities.invoke_and_wait do
        @ui = MainWindow.new
      end
    end

    def join_auction(connection, item_id)
      disconnect_when_ui_closes(connection)
      chat = connection.get_chat_manager.
        create_chat(auction_id(item_id, connection), nil)
      auction = XMPPAuction.new(chat)
      chat.add_message_listener(
                    AuctionMessageTranslator.new(
                      connection.get_user,
                      AuctionSniper.new(auction,
                                        SniperStateDisplayer.new(@ui))))
      @not_to_be_garbage_collected = chat
      auction.join
    end

    def auction_id(item_id, connection)
      AUCTION_ID_FORMAT % [item_id, connection.get_service_name]
    end

    class SniperStateDisplayer

      def initialize(ui)
        @ui = ui
      end

      def sniper_bidding
        Swing::SwingUtilities.invoke_later do
          show_status(MainWindow::STATUS_BIDDING)
        end
      end

      def sniper_lost
        Swing::SwingUtilities.invoke_later do
          show_status(MainWindow::STATUS_LOST)
        end
      end

      def sniper_won
        Swing::SwingUtilities.invoke_later do
          show_status(MainWindow::STATUS_WON)
        end
      end

      def sniper_winning
        Swing::SwingUtilities.invoke_later do
          show_status(MainWindow::STATUS_WINNING)
        end
      end

      private
      def show_status(status)
        Swing::SwingUtilities.invoke_later { @ui.show_status(status) }
      end
    end


    def disconnect_when_ui_closes(connection)
      window_adapter = WindowAdapter.new
      window_adapter.connection = connection
      @ui.add_window_listener(window_adapter)
    end

    class WindowAdapter < AWT::WindowAdapter
      attr_accessor :connection
      def windowClosed(event)
        connection.disconnect
      end
    end

  end
end
