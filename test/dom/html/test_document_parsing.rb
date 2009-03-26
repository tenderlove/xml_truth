require 'helper'

module XmlTruth
  module DOM
    module HTML
      ###
      # This benchmark is for comparing document parsing speeds
      class DocumentParsingTest < TestCase
        def setup
          @n          = (ENV['N'] || 100).to_i
          @file_list  = Dir[File.join(ASSETS, 'html', '*.html')]

          @stat = Struct.new(:size).new(
            @file_list.map { |x|
              File.stat(x)
            }.inject(0) { |m,o| m + o.size }
          )

          GC.start
        end

        def teardown
          GC.start
        end

        def test_in_memory_parsing
          bm(12) do |x|
            GC.start
            measure('hpricot') do @n.times {
              @file_list.each { |file| Hpricot(File.read(file)) }
            } end

            GC.start
            measure('nokogiri') do @n.times {
              @file_list.each { |file| Nokogiri::HTML(File.read(file)) }
            } end

            # libxml-ruby breaks
            #GC.start
            #measure('libxml-ruby') do @n.times {
            #  LibXML::XML::HTMLParser.string(@html).parse
            #} end
          end
        end

        def test_IO_parsing
          bm(12) do |x|
            GC.start
            measure('hpricot') do @n.times {
              @file_list.each { |file| File.open(file) { |html| Hpricot(html) }}
            } end

            GC.start
            measure('nokogiri') do @n.times {
              @file_list.each { |file|
                File.open(file) { |html| Nokogiri::HTML(html) }
              }
            } end
          end
        end
      end
    end
  end
end
