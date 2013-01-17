require 'lib/window_licker'
require 'lib/hamcrest'

class ApplicationRunner
  class AuctionSniperDriver < WindowLicker::JFrameDriver
    def initialize(timeout)
      gesture_performer = WindowLicker::GesturePerformer.new
      top_level_driver = WindowLicker::JFrameDriver.top_level_frame(
        named(AuctionSniper::MainWindow::MAIN_WINDOW_NAME), showing_on_screen)
      event_queue_probe = WindowLicker::AWTEventQueueProber.new(timeout, 100)
      super(gesture_performer, top_level_driver, event_queue_probe)
    end

    def self.with_timeout(timeout)
      gesture_performer = WindowLicker::GesturePerformer.new
      top_level_driver = WindowLicker::JFrameDriver.top_level_frame(
        named(AuctionSniper::MainWindow::MAIN_WINDOW_NAME), showing_on_screen)
      event_queue_probe = WindowLicker::AWTEventQueueProber.new(timeout, 100)
      new(gesture_performer, top_level_driver, event_queue_probe)
    end

    def shows_sniper_status(text)
      snipers_table.has_cell(with_label_text(equal_to(text)))
    end
  end
end
