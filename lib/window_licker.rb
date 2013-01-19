require 'java'
require 'java_lib/hamcrest/hamcrest-all-SNAPSHOT.jar'
require 'java_lib/window_licker/windowlicker-swing-DEV.jar'
require 'java_lib/window_licker/windowlicker-core-DEV.jar'

module WindowLicker
  include_package 'com/objogate/wl'
  include_package 'com/objogate/wl/swing'
  java_import com.objogate.wl.swing.AWTEventQueueProber
  java_import com.objogate.wl.swing.driver.JFrameDriver
  java_import com.objogate.wl.swing.driver.JLabelDriver
  java_import com.objogate.wl.swing.driver.JTableDriver
  java_import com.objogate.wl.swing.driver.JTableHeaderDriver
  java_import com.objogate.wl.swing.gesture.GesturePerformer
  java_import com.objogate.wl.swing.matcher.JLabelTextMatcher
  java_import com.objogate.wl.swing.matcher.IterableComponentsMatcher
end
