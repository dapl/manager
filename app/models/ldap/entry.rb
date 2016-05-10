module LDAP
  class Entry
    def initialize(entry)
      @_data = entry
    end

    def objectclasses
      @_data.objectclass
    end

    def attribute_names
      @_data.attribute_names
    end

    def dn
      @_data.dn
    end

    def cn
      @_data.cn.first
    end

    class << self
      def admin
        LDAP::Connection.instance
      end
    end
  end
end
