module Spree
  module Amazon
    class Variant < Spree::Amazon::Product
      attr_accessor :product
      # attr_accessor :variant_attributes

      def options_text
        (@variant_options || []).map{ |x|
          "#{x[:name]}: #{x[:value]}"
        }.to_sentence({:words_connector => ", ", :two_words_connector => ", "})
      end
      def in_stock
        1
      end
      def option_values
        @variant_options || []
      end


      # def option_values
      #       self.option_values.sort{|ov1, ov2| ov1.option_type.position <=> ov2.option_type.position}.map { |ov| "#{ov.option_type.presentation}: #{ov.presentation}" }.to_sentence({:words_connector => ", ", :two_words_connector => ", "})

      #   [ ]
      # end
      class << self
        def build_variants_collection(product, variants=[])
          Spree::Amazon::VariantCollection.new( (variants).map{ |x| new(x.merge(:product => product)) } )
        end
      end
    end

  end
end
