require 'helper'

module XmlTruth
  module DOM
    module XML
      ###
      # This benchmark is for comparing document parsing speeds
      class LargeDocumentParsingTest < TestCase
        def setup
          puts
          puts "#{name} N=#{N}"
          @filename = File.join(ASSETS, 'itunes.xml')
          @stat = File.stat(@filename)
          @xml = File.read(@filename)
          GC.start
        end

        def teardown
          GC.start
        end

        def test_in_memory_parsing
          bm(12) do |x|
            measure('null') do N.times {
              @xml.split(/\n/)
            } end

            GC.start
            measure('nokogiri') do N.times {
              Nokogiri::XML(@xml)
            } end

            GC.start
            measure('libxml-ruby') do N.times {
              LibXML::XML::Parser.string(@xml).parse
            } end

            if ENV['SLOW']
              GC.start
              measure('hpricot') do N.times {
                Hpricot(@xml)
              } end

              GC.start
              measure('rexml') do N.times {
                REXML::Document.new(@xml)
              } end
            end
          end
        end

        def test_IO_parsing
          bm(12) do |x|
            measure('null') do N.times {
              File.open(@filename) { |xml|
                xml.each_line { |line| }
              }
            } end

            GC.start
            measure('nokogiri') do N.times {
              File.open(@filename) { |xml| Nokogiri::XML(xml) }
            } end

            GC.start
            measure('libxml-ruby') do N.times {
              File.open(@filename) { |xml| LibXML::XML::Parser.io(xml).parse }
            } end

            if ENV['SLOW']
              GC.start
              measure('hpricot') do N.times {
                File.open(@filename) { |xml| Hpricot(xml) }
              } end

              GC.start
              measure('rexml') do N.times {
                File.open(@filename) { |xml| REXML::Document.new(xml) }
              } end
            end
          end
        end
      end
    end
  end
end
