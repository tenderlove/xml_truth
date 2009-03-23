require 'helper'

module XmlTruth
  module DOM
    module XML
      ###
      # This benchmark is for comparing document parsing speeds
      class LargeDocumentXPathSearchTest < TestCase
        def setup
          @n        = (ENV['N'] || 1000).to_i
          @filename = File.join(ASSETS, 'timeline.xml')
          @stat     = File.stat(@filename)
          @xml      = File.read(@filename)

          puts
          puts "#{name} N=#{@n}"

          @ndoc = Nokogiri::XML(@xml)
          @ldoc = LibXML::XML::Parser.string(@xml).parse
          @hdoc = Hpricot.XML(@xml)

          if ENV['REXML']
            @rdoc = REXML::Document.new(@xml)
          end

          GC.start
        end

        def teardown
          GC.start
        end

        def test_tree_traversal
          bm(12) do |x|
            GC.start
            measure('nokogiri') do @n.times {
              list = @ndoc.root.children.to_a
              while !list.empty?
                list += list.pop.children
              end
            } end

            GC.start
            measure('libxml-ruby') do @n.times {
              list = @ldoc.root.children
              while !list.empty?
                list += list.pop.children
              end
            } end

            GC.start
            measure('hpricot') do @n.times {
              list = @hdoc.root.children
              while !list.empty?
                node = list.pop
                next unless node.respond_to?(:children)
                next unless node.children
                list += node.children
              end
            } end
          end
        end
      end
    end
  end
end
