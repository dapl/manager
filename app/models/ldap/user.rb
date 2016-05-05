module LDAP
  class User < Entry
    def initialize(entry)
      @_data = entry
    end

    # attr_reader :groups

    def uid
      @_data.uidnumber.first
    end

    def login
      @_data.uid.first
    end

    def password
      @_data.userpassword.first
    end

    def groups
      Rails.cache.fetch("ldap.users.#{self.login}.groups") do
        LDAP::Group.for_user(login)
      end
    end

    def name
      @_data.gecos.first
    end

    def email
      @_data.mail.first rescue nil
    end

    def keys
      @_data.sshpublickey
    end

    def shell
      @_data.loginshell.first
    end

    def enabled?
      employeetype == 1
    end

    def disabled?
      employeetype == 0
    end

    def employeetype
      @_data.employeetype.first.to_i
    end

    def as_json(options=nil)
      Rails.cache.fetch("ldap.users.#{self.login}.user") do
        {
            id: self.login,
            login: self.login,
            dn: self.dn,
            uid: self.uid,
            # password: self.password,
            groups: self.groups,
            name: self.name,
            email: self.email,
            keys: self.keys.map{|e| e.split.last},
            shell: self.shell,
            enabled: self.enabled?,
            employeetype: self.employeetype
        }
      end
    end

    def to_hash
      {
          id: self.login,
          login: self.login,
          dn: self.dn,
          uid: self.uid,
          # password: self.password,
          groups: self.groups,
          name: self.name,
          email: self.email,
          keys: self.keys.map{|e| e.split.last},
          shell: self.shell,
          enabled: self.enabled?,
          employeetype: self.employeetype
      }
    end

    def to_ldap
      {

      }
    end

    class << self
      def find(login)
        admin.get_user(login)
      end

      def all
        admin.users
      end

      def create(login, first_name, last_name, key, custom_attrs={})
        admin.user_create(login, first_name, last_name, key, custom_attrs)
      end

      def update(login, attrs)
        admin.user_update(login, attrs)
        cache_delete(login)
      end

      def password(login, password)
        admin.user_password(login, password)
      end

      def enable(login)
        admin.user_enable(login)
        cache_delete(login)
      end

      def disable(login)
        admin.user_disable(login)
        cache_delete(login)
      end

      def add_group(login, group)
        admin.user_group_add(login, group)
        cache_delete(login)
      end

      def remove_group(login, group)
        admin.user_group_remove(login, group)
        cache_delete(login)
      end

      def add_key(login, key)
        admin.user_key_add(login, key)
        cache_delete(login)
      end

      def remove_key(login, key_name)
        admin.user_key_remove(login, key_name)
        cache_delete(login)
      end

      def destroy(login)
        admin.user_destroy(login)
        cache_delete(login)
      end

      private

      def cache_delete(login)
        Rails.cache.delete_matched("ldap.users.#{login}.*")
      end
    end
  end
end
