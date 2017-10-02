require 'hanami/auth/version'
require 'bcrypt'

module Hanami
  module Auth

    private

    def login(user, remember_me: false, expire_seconds: 1 * 60 * 60)
      return if authenticated?
      session[:current_user] = user
      session[:session_created_at] = Time.now + expire_seconds
      session[:remember_me] = remember_me
    end

    def logout
      return unless authenticated?
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
        flash[:error] = 'セッションの有効期限が切れました'
        redirect_to routes.root_path
      elsif !authenticated?
        flash[:error] = 'ログインしてください'
        redirect_to routes.root_path
      end
    end

    def authenticated?
      !!session[:current_user]
    end

    def session_expired?
      !session[:remember_me] && session[:session_expired_at] && session[:session_expired_at] < Time.now
    end
  end
end
