module Spree
  module Amazon

    # For paginate
    #
    class ProductCollection < Array
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
    end


  end
end

