module Spree
  module Amazon
    class Base
      extend ActiveModel::Naming
      extend ActiveModel::Callbacks

      include ActiveModel::Validations
      include ActiveModel::MassAssignmentSecurity
      include ActiveModel::Conversion
      include ActiveModel::AttributeMethods
      include ActiveModel::Serialization



      class << self

      end # end class << self

      def initialize(*args)
        fields = args.extract_options!
        fields.each {|k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
      end

      def attributes=(attrs={ })
        attrs.each {|k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
      end

      def to_param
        @id.to_s
      end

    end
  end
end
