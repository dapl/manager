module LDAP
  class Group < Entry
    def initialize(entry)
      @_data = entry
    end

    def name
      cn
    end

    def gid
      @_data.gidnumber.first
    end

    def members
      @_data.memberuid rescue []
    end

    def as_json(options=nil)
      Rails.cache.fetch("ldap.groups.#{name}.group") do
        {
            id: self.name,
            name: self.name,
            gid: self.gid,
            members: self.members,
        }
      end
    end

    class << self
      def find(name)
        admin.get_group(name)
      end

      def all
        admin.groups
      end

      def update(name, attrs)
        raise "not implemented"
      end

      def for_user(login)
        admin.get_user_groups(login)
      end

      def add_user(name, login)
        admin.user_group_add(login, name)
        cache_delete(name)
      end

      def remove_user(name, login)
        admin.user_group_remove(login, name)
        cache_delete(name)
      end

      def create(name)
        admin.group_create(name)
      end

      def destroy(name)
        admin.group_destroy(name)
      end

      private

      def cache_delete(name)
        Rails.cache.delete_matched("ldap.groups.#{name}.*")
      end
    end
  end
end
