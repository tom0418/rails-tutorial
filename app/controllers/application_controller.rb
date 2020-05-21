class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :sign_in, :sign_out
  include SessionsHelper

  private

  # before filter

  # サインイン済みのユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please Sign in.'
    redirect_to signin_url
  end

  # helper method

  # 現在サインイン中のユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        sign_in user
        @current_user = user
      end
    end
  end

  # サインインしているかの判定
  def logged_in?
    !current_user.nil?
  end

  # 渡されたユーザーでサインインする
  def sign_in(user)
    session[:user_id] = user.id
  end

  # 現在のユーザーをサインアウトする
  def sign_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
