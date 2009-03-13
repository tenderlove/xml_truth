# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/xml_truth.rb'

Hoe.new('xml_truth', XmlTruth::VERSION) do |p|
  p.developer('Aaron Patterson', 'aaronp@rubyforge.org')
  p.readme_file   = ['README', ENV['HLANG'], 'rdoc'].compact.join('.')
  p.history_file  = ['CHANGELOG', ENV['HLANG'], 'rdoc'].compact.join('.')
  p.extra_rdoc_files  = FileList['*.rdoc']
end

# vim: syntax=Ruby
