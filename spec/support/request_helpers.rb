module Requests
  module AuthenticationHelper
    def is_signed_in?
      !session[:user_id].nil?
    end
  end

  module SessionsHelper
    def sign_in(path, email: 'test@example.com', password: 'password')
      post path, params: { session: { email: email,
                                      password: password } }
    end

    def sign_in_with_remember(path, remember_me: '1')
      post path, params: { session: { email: 'test@example.com',
                                      password: 'password',
                                      remember_me: remember_me } }
    end
  end

  module UsersHelper
    def sign_up(path,
                name: 'Test User',
                email: 'test@example.com',
                password: 'password',
                confirmation: 'password')
      post path, params: { user: { name: name,
                                   email: email,
                                   password: password,
                                   password_confirmation: confirmation } }
    end

    def update_user(path,
                    name: 'Edit User',
                    email: 'edit_test@example.com',
                    password: 'edit_password',
                    confirmation: 'edit_password')
      patch path, params: { user: { name: name,
                                    email: email,
                                    password: password,
                                    password_confirmation: confirmation } }
    end
  end
end
