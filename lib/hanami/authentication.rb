require 'hanami/authentication/version'
require 'bcrypt'

module Hanami
  module Authentication

    private

    def login(user, remember_me: false, expire_seconds: 1 * 60 * 60)
      session[:current_user] = user
      session[:session_created_at] = Time.now + expire_seconds
      session[:remember_me] = remember_me
    end

    def logout
      session[:current_user] = nil
      session[:session_created_at] = nil
      session[:remember_me] = nil
    end

    def create_password(password)
      BCrypt::Password.create(password)
    end

    def match_password?(user, password)
      user && BCrypt::Password.new(user.password_digest) == password
    end

    def current_user
      @current_user ||= session[:current_user]
    end

    def authenticate!
      if session_expired? || !authenticated?
        logout
        halt 401
      end
    end

    def authenticate
      if session_expired?
        logout
        self.class.after_session_expired_callbacks.run(self)
      elsif !authenticated?
        self.class.after_authentication_failed_callbacks.run(self)
      end
    end

    def authenticated?
      !!session[:current_user]
    end

    def session_expired?
      !session[:remember_me] && session[:session_expired_at] && session[:session_expired_at] < Time.now
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

          class_attribute :after_session_expired_callbacks
          self.after_session_expired_callbacks = Utils::Callbacks::Chain.new

          class_attribute :after_authentication_failed_callbacks
          self.after_authentication_failed_callbacks = Utils::Callbacks::Chain.new
        end
      end

      def after_session_expired(*callbacks, &blk)
        after_session_expired_callbacks.append(*callbacks, &blk)
      end

      def after_authentication_failed(*callbacks, &blk)
        after_authentication_failed_callbacks.append(*callbacks, &blk)
      end
    end
  end
end
