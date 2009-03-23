require 'helper'

module XmlTruth
  module DOM
    module HTML
      ###
      # This benchmark is for comparing document parsing speeds
      class DocumentParsingTest < TestCase
        def setup
          @n        = (ENV['N'] || 100).to_i
          @filename = File.join(ASSETS, 'tlm.html')
          @stat     = File.stat(@filename)
          @html      = File.read(@filename)

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
              @html.split(/\n/)
            } end

            GC.start
            measure('nokogiri') do @n.times {
              Nokogiri::HTML(@html)
            } end

            #GC.start
            #measure('libxml-ruby') do @n.times {
            #  LibXML::XML::HTMLParser.string(@html).parse
            #} end

            GC.start
            measure('hpricot') do @n.times {
              Hpricot(@html)
            } end
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
              File.open(@filename) { |xml| Nokogiri::HTML(xml) }
            } end

            #GC.start
            #measure('libxml-ruby') do @n.times {
            #  File.open(@filename) { |xml| LibXML::XML::HTMLParser.io(xml).parse }
            #} end

            GC.start
            measure('hpricot') do @n.times {
              File.open(@filename) { |xml| Hpricot(xml) }
            } end
          end
        end
      end
    end
  end
end
