module JwtCookieHelper
  def set_jwt_cookie(resource)
    token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

    cookies.signed[:jwt] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: resolve_same_site_policy
    }
  end

  def delete_jwt_cookie
    cookies.delete(:jwt, secure: Rails.env.production?, same_site: resolve_same_site_policy)
  end

  private

  def resolve_same_site_policy
    if Rails.env.production?
      allowed_origins = ENV.fetch("CORS_ALLOWED_ORIGINS", "").split(",")
      origin = request.headers["Origin"]
      allowed_origins.include?(origin) ? :none : :lax
    else
      :lax
    end
  end
end