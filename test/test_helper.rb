require 'test/unit'
require 'set'

require File.dirname(__FILE__) + '/../lib/oauth'

begin
  # load redgreen unless running from within TextMate (in which case ANSI
  # color codes mess with the output)
  require 'redgreen' unless ENV['TM_CURRENT_LINE']
rescue LoadError
  nil
end


class Test::Unit::TestCase
  def extract_sorted_array_from_authorization_spec(spec)
    return spec.gsub(/^OAuth\s/,"").split(', ').sort
  end
end