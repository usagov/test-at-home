class KitRequestsController < ApplicationController
  def new
    @kit_request = KitRequest.new
  end

  def create
    @kit_request = KitRequest.new(kit_request_params)

    if recaptcha_valid?(params["g-recaptcha-response"]) && @kit_request.save
      render :confirmation
    else
      render :new
    end
  end

  def confirmation
  end

  private

  def recaptcha_valid?(user_response)
    return true unless ENV["RECAPTCHA_REQUIRED"] == "true"
    return false if user_response.blank?
    uri = URI("https://www.google.com/recaptcha/api/siteverify")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Post.new uri
      request.set_form_data secret: Rails.application.credentials.recaptcha.site_secret, response: user_response
      http.request request
    end
    json = JSON.parse response.body
    json["success"]
  end

  def kit_request_params
    params.require(:kit_request).permit(
      :first_name,
      :last_name,
      :email,
      :mailing_address_1,
      :mailing_address_2,
      :city,
      :state,
      :zip_code
    )
  end
end
