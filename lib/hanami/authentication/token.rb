require 'hanami/authentication/version'
require 'bcrypt'
require 'securerandom'

module Hanami
  module Authentication
    module Token
      private

      def create_token
        SecureRandom.uuid
      end

      def current_user
        @current_user
      end

      def authenticate(params)
        bearer_token = token_from_header
        halt 401 unless bearer_token
        token = self.class.find_token_block.call(bearer_token)
        halt 401 unless token
        @current_user = self.class.find_user_block.call(token)
        halt 401 unless @current_user
      end

      def authenticated?
        !!@current_user
      end

      def token_from_header
        header = request.get_header('HTTP_AUTHORIZATION')
        return unless header
        matched = header.match(/Bearer (.+)$/)
        matched && matched[1]
      end

      def self.included(base)
        base.class_eval do
          _expose :current_user
          extend  ClassMethods
        end
      end

      module ClassMethods
        def self.extended(base)
          base.class_eval do
            include Utils::ClassAttribute
            class_attribute :find_user_block
            class_attribute :find_token_block
          end
        end

        def user_for_authenticate(&blk)
          self.find_user_block = blk
        end

        def token_for_authenticate(&blk)
          self.find_token_block = blk
        end
      end
    end
  end
end
