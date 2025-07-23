module JwtCookieHelper
  def set_jwt_cookie(resource)
    token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

    same_site =
      if Rails.env.production?
        allowed_origins = ENV.fetch("CORS_ALLOWED_ORIGINS", "").split(",")
        origin = request.headers["Origin"]
        allowed_origins.include?(origin) ? :none : :lax
      else
        :lax
      end

    cookies.signed[:jwt] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: same_site
    }
  end
end
