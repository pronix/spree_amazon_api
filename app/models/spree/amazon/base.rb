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

        def cache(key, options = {:expires_in => 1.weeks })
          Rails.cache.fetch("#{ prefix_key }_#{key}",options){ yield }
        end
        def class_name
          "#{name}"
        end
      end # end class << self

      def initialize(*args)
        fields = args.extract_options!
        fields.each {|k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
      end

      def attributes=(attrs={ })
        attrs.each {|k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
      end
      # Сохраняем объект в memcached
      #
      # == Parameters:
      # return_key_or_obj::
      #   Ключ возвращаемого результат, :key or :obj
      #
      # == Returns:
      # Если ключ равен :key то вернется ключ по которому запись сохраненя в memcached
      # Иначе вернется текущий объект
      #
      def save_to_mem(return_key_or_obj = :key)
        Rails.cache.write("#{self.class.prefix_key}_#{mem_key}",
                          self,  :expires_in => 1.weeks) && (return_key_or_obj.to_sym == :key ? self.mem_key : self)
      end

      def mem_key
        "#{self.class.class_name}-#{self.id}"
      end

      def to_param
        @id.to_s
      end

    end
  end
end
