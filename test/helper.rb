require 'test/unit'
require 'benchmark'
require 'rubygems'
require 'hpricot'
require 'rexml/document'
require 'libxml'
require 'nokogiri'

ASSETS  = File.expand_path(File.join(File.dirname(__FILE__), 'assets'))

puts
puts "Nokogiri: #{Nokogiri::VERSION}"
puts "LibXML: #{LibXML::XML::VERSION}"
puts

module XmlTruth
  module Tms
    attr_accessor :stat, :n

    def format arg0 = nil
      super("%10.6u %10.6y %10.6t %10.6r %0.2f\n", kbps)
    end

    def kbps
      stat.size * n / 1024.0 / real
    end
  end

  class TestCase < Test::Unit::TestCase
    include Benchmark

    unless RUBY_VERSION >= '1.9'
      undef :default_test
    end
    alias :old_measure :measure
    def measure label = "", &block
      tms = old_measure(label, &block)
      tms.extend(XmlTruth::Tms)
      tms.stat  = @stat
      tms.n     = @n
      print label.ljust(@width)
      print tms.format
    end

    alias :old_bm :bm
    def bm(label_width = 0, *labels, &blk)
      @width = label_width
      c = "#{CAPTION.chomp}   kbps\n"
      benchmark(" "*label_width + c, label_width, FMTSTR, *labels, &blk)
    end
  end
end
