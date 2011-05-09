module Spree
  module Amazon

    # For paginate
    #
    class ProductCollection < Array
      MAX_TOTAL_PAGES = 200
      attr_accessor_with_default :total_entries, 0
      attr_accessor_with_default :total_pages,   1
      attr_accessor_with_default :current_page,  1

      def per_page
        10
      end

      # The previous page number. Returns nil if on first page.
      def previous_page
        @current_page > 1 ? (@current_page - 1) : nil
      end

      # The next page number. Returns nil if on last page.
      def next_page
        @current_page < total_pages ? (@current_page + 1): nil
      end

      # Total number of pages with found results.
      def total_pages
        (@total_entries.to_i / per_page.to_f).ceil
      end

      def current_page
        @current_page
      end

      def current_page=(v)
        @current_page = v
      end

      class << self
        def build(options = { })
          @collection = new(options[:products])
          @max_total_pages = options[:search_index].to_s == "All" ? 5 : MAX_TOTAL_PAGES
          @collection.total_entries = @collection.total_pages = build_total_pages(options[:total_entries], @max_total_pages)
          @collection.current_page  = options[:current_page] || 1
          @collection
        end

        def empty_build
          @collection = new([])
          @collection.total_entries = 1
          @collection.current_page  = 1
          @collection
        end

        def build_total_pages(total_pages, max_total_pages)
          if total_pages.to_i >= max_total_pages.to_i
            max_total_pages.to_i
          elsif total_pages.to_i == 0
            1
          else
            total_pages.to_i
          end
        end

      end # end class << self

    end


  end
end

