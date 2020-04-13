module SessionsHelper
  # 渡されたユーザでログインする
  def sign_in(user)
    session[:user_id] = user.id
  end

  # ユーザのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザをログアウトする
  def sign_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
