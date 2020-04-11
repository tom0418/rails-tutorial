module Requests
  module AuthenticationHelper
    def is_signed_in?
      !session[:user_id].nil?
    end
  end

  module SessionsHelper
    def valid_sign_in(path)
      post path, params: { session: { email: 'test@example.com',
                                      password: 'password' } }
    end

    def invalid_sign_in(path)
      post path, params: { session: { email: 'test@example.com',
                                      password: 'invalid-password'} }
    end
  end

  module UsersHelper
    def valid_sign_up(path)
      post path, params: { user: { name: 'Test User',
                                         email: 'test@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end

    def invalid_sign_up(path)
      post path, params: { user: { name: 'Test User',
                                         email: 'test@example.com',
                                         password: 'password',
                                         password_confirmation: 'invalid' } }
    end
  end
end

