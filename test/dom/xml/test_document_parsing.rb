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

        def test_small_in_memory_parsing
          puts name
          xml = File.read(File.join(ASSETS, 'timeline.xml'))
          Benchmark.bm(12) do |x|
            x.report('null') do N.times {
              GC.start
              xml.split(/\n/)
            } end

            x.report('nokogiri') do N.times {

              GC.start
              Nokogiri::XML(xml)

            } end

            x.report('libxml-ruby') do N.times {

              GC.start
              LibXML::XML::Parser.string(xml).parse

            } end

            if ENV['SLOW']
              x.report('hpricot') do N.times {

                GC.start
                Hpricot(xml)

              } end

              x.report('rexml') do N.times {

                GC.start
                REXML::Document.new(xml)

              } end
            end
          end
        end

        def test_large_in_memory_parsing
          puts name
          xml = File.read(File.join(ASSETS, 'itunes.xml'))
          Benchmark.bm(12) do |x|
            x.report('null') do N.times {
              GC.start
              xml.split(/\n/)
            } end

            x.report('nokogiri') do N.times {

              GC.start
              Nokogiri::XML(xml)

            } end

            x.report('libxml-ruby') do N.times {

              GC.start
              LibXML::XML::Parser.string(xml).parse

            } end

            if ENV['SLOW']
              x.report('hpricot') do N.times {

                GC.start
                Hpricot(xml)

              } end

              x.report('rexml') do N.times {

                GC.start
                REXML::Document.new(xml)

              } end
            end
          end
        end

        def test_small_IO_parsing
          puts name
          Benchmark.bm(12) do |x|
            x.report('null') do N.times {
              GC.start
              File.open(File.join(ASSETS, 'timeline.xml')) { |xml|
                xml.each_line { |line| }
              }
            } end

            x.report('nokogiri') do N.times {

              GC.start
              File.open(File.join(ASSETS, 'timeline.xml')) { |xml|
                Nokogiri::XML(xml)
              }

            } end

            x.report('libxml-ruby') do N.times {

              GC.start
              File.open(File.join(ASSETS, 'timeline.xml')) { |xml|
                LibXML::XML::Parser.io(xml).parse
              }

            } end

            if ENV['SLOW']
              x.report('hpricot') do N.times {

                GC.start
                File.open(File.join(ASSETS, 'timeline.xml')) { |xml|
                  Hpricot(xml)
                }

              } end

              x.report('rexml') do N.times {

                GC.start
                File.open(File.join(ASSETS, 'timeline.xml')) { |xml|
                  REXML::Document.new(xml)
                }

              } end
            end
          end
        end

        def test_large_IO_parsing
          puts name
          Benchmark.bm(12) do |x|
            x.report('null') do N.times {
              GC.start
              File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                xml.each_line { |line| }
              }
            } end

            x.report('nokogiri') do N.times {

              GC.start
              File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                Nokogiri::XML(xml)
              }

            } end

            x.report('libxml-ruby') do N.times {

              GC.start
              File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                LibXML::XML::Parser.io(xml).parse
              }

            } end

            if ENV['SLOW']
              x.report('hpricot') do N.times {

                GC.start
                File.open(File.join(ASSETS, 'itunes.xml')) { |xml|
                  Hpricot(xml)
                }

              } end

              x.report('rexml') do N.times {

                GC.start
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
