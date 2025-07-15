class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json

  protected

  def configure_permitted_parameters
    added_keys = [
      :email, :password, :password_confirmation,
      :first_name, :last_name,
      :first_name_kana, :last_name_kana,
      :birth_date, :phone_number,
      :gender, :prefecture
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_keys)
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :email, :password ])
    devise_parameter_sanitizer.permit(:account_update, keys: added_keys)
  end
end
