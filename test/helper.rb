require 'test/unit'
require 'benchmark'
require 'rubygems'
require 'hpricot'
require 'rexml/document'
require 'libxml'
require 'nokogiri'

ASSETS  = File.expand_path(File.join(File.dirname(__FILE__), 'assets'))
N       = (ENV['N'] || 100).to_i

puts "Nokogiri: #{Nokogiri::VERSION}"
