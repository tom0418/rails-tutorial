module Requests
  module AuthenticationHelper
    def is_signed_in?
      !session[:user_id].nil?
    end
  end

  module SessionsHelper
    def sign_in(url, email: 'test@example.com', password: 'password')
      post url, params: { session: { email: email,
                                     password: password } }
    end

    def sign_in_with_remember(url, remember_me: '1')
      post url, params: { session: { email: 'test@example.com',
                                     password: 'password',
                                     remember_me: remember_me } }
    end
  end

  module UsersHelper
    def sign_up(url,
                name: 'Test User',
                email: 'test@example.com',
                password: 'password',
                confirmation: 'password')
      post url, params: { user: { name: name,
                                  email: email,
                                  password: password,
                                  password_confirmation: confirmation } }
    end

    def update_user(url,
                    name: 'Edit User',
                    email: 'edit_test@example.com',
                    password: 'edit_password',
                    confirmation: 'edit_password')
      patch url, params: { user: { name: name,
                                   email: email,
                                   password: password,
                                   password_confirmation: confirmation } }
    end
  end

  module PasswordResetsHelper
    def reset_password(url, email: 'test@example.com')
      post url, params: { password_reset: { email: email } }
    end

    def update_password(url,
                        email: 'test@example.com',
                        password: 'edit_password',
                        confirmation: 'edit_password')
      patch url, params: { email: email,
                           user: { password: password,
                                   password_confirmation: confirmation } }
    end
  end

  module MicropostsHelper
    def post_microposts(url, content: 'Test micropost.', picture: nil)
      post url, params: { micropost: { content: content,
                                       picture: picture } }
    end
  end
end
