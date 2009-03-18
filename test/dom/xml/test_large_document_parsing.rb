require 'helper'

module XmlTruth
  module DOM
    module XML
      ###
      # This benchmark is for comparing document parsing speeds
      class LargeDocumentParsingTest < TestCase
        def setup
          @n        = (ENV['N'] || 100).to_i
          @filename = File.join(ASSETS, 'itunes.xml')
          @stat     = File.stat(@filename)
          @xml      = File.read(@filename)

          puts
          puts "#{name} N=#{@n}"

          GC.start
        end

        def teardown
          GC.start
        end

        def test_in_memory_parsing
          bm(12) do |x|
            measure('null') do @n.times {
              @xml.split(/\n/)
            } end

            GC.start
            measure('nokogiri') do @n.times {
              Nokogiri::XML(@xml)
            } end

            GC.start
            measure('libxml-ruby') do @n.times {
              LibXML::XML::Parser.string(@xml).parse
            } end

            GC.start
            measure('hpricot') do @n.times {
              Hpricot.XML(@xml)
            } end

            if ENV['SLOW']
              GC.start
              measure('rexml') do @n.times {
                REXML::Document.new(@xml)
              } end
            end
          end
        end

        def test_IO_parsing
          bm(12) do |x|
            measure('null') do @n.times {
              File.open(@filename) { |xml|
                xml.each_line { |line| }
              }
            } end

            GC.start
            measure('nokogiri') do @n.times {
              File.open(@filename) { |xml| Nokogiri::XML(xml) }
            } end

            GC.start
            measure('libxml-ruby') do @n.times {
              File.open(@filename) { |xml| LibXML::XML::Parser.io(xml).parse }
            } end

            GC.start
            measure('hpricot') do @n.times {
              File.open(@filename) { |xml| Hpricot(xml) }
            } end

            if ENV['SLOW']
              GC.start
              measure('rexml') do @n.times {
                File.open(@filename) { |xml| REXML::Document.new(xml) }
              } end
            end
          end
        end
      end
    end
  end
end

module XmlTruth
  module DOM
    module XML
      ###
      # This benchmark is for comparing document parsing speeds
      class SmallDocumentParsingTest < LargeDocumentParsingTest
        def setup
          @filename = File.join(ASSETS, 'timeline.xml')
          @stat     = File.stat(@filename)
          @xml      = File.read(@filename)

          stat = File.stat(File.join(ASSETS, 'itunes.xml'))

          # Try to process the same amount of data as the large
          # document test.
          @n        = ((ENV['N'] || 100).to_i *
            (stat.size / @stat.size.to_f)).to_i

          puts
          puts "#{name} N=#{@n}"

          GC.start
        end
      end
    end
  end
end
