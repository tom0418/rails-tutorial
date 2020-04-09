module Requests
  module AuthenticationHelper
    def is_signed_in?
      !session[:user_id].nil?
    end
  end
end

