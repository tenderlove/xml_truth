require 'helper'

module XmlTruth
  module DOM
    module XML
      ###
      # This benchmark is for comparing document parsing speeds
      class DocumentParsingTest < Test::Unit::TestCase
        def setup
          GC.start
        end

        def teardown
          GC.start
        end

        def test_large_in_memory_parsing
          puts
          puts name
          xml = File.read(File.join(ASSETS, 'itunes.xml'))
          Benchmark.bm(12) do |x|
            x.report('null') do N.times {
              xml.split(/\n/)
            } end

            GC.start
            x.report('nokogiri') do N.times {
              Nokogiri::XML(xml)
            } end

            GC.start
            x.report('libxml-ruby') do N.times {
              LibXML::XML::Parser.string(xml).parse
            } end

            if ENV['SLOW']
              GC.start
              x.report('hpricot') do N.times {
                Hpricot(xml)
              } end

              GC.start
              x.report('rexml') do N.times {
                REXML::Document.new(xml)
              } end
            end
          end
        end

        def test_large_IO_parsing
          puts
          puts name
          Benchmark.bm(12) do |x|
            x.report('null') do N.times {
              File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                xml.each_line { |line| }
              }
            } end

            GC.start
            x.report('nokogiri') do N.times {
              File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                Nokogiri::XML(xml)
              }
            } end

            GC.start
            x.report('libxml-ruby') do N.times {
              File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                LibXML::XML::Parser.io(xml).parse
              }
            } end

            if ENV['SLOW']
              GC.start
              x.report('hpricot') do N.times {
                File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                  Hpricot(xml)
                }
              } end

              GC.start
              x.report('rexml') do N.times {
                File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                  REXML::Document.new(xml)
                }
              } end
            end
          end
        end
      end
    end
  end
end
