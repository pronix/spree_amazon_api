module SpreeEcs
  class Base
    class << self
      def cache(key, options = { :expires_in => 1.day })
        Rails.cache.fetch("#{Digest::SHA1.hexdigest(key)}",options){ yield }
      end
    end
  end
end
