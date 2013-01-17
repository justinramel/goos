require 'java'
require 'java_lib/smack/smack.jar'
require 'java_lib/smack/smackx.jar'

module Smack
  include_package 'org/jivesoftware/smack'
  java_import org.jivesoftware.smack.XMPPConnection
  java_import org.jivesoftware.smack.packet.Message
end
