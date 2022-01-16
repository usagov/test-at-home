class KitRequestsController < ApplicationController
  def new
    @kit_request = KitRequest.new
    response.set_header("Cache-Control", "public, max-age=#{ENV["CACHE_FORM_AGE"]}")
  end

  def create
    @kit_request = KitRequest.new(kit_request_params)

    if recaptcha_completed?(params["g-recaptcha-response"]) && @kit_request.save
      render_confirmation
    else
      render :new
    end
  end

  private

  def recaptcha_completed?(token)
    return true unless ENV["RECAPTCHA_REQUIRED"] == "true"
    return false unless token && token.present?

    # https://cloud.google.com/recaptcha-enterprise/docs/create-assessment#rest-api
    uri = URI.parse("https://recaptchaenterprise.googleapis.com/v1beta1/projects/#{ENV["RECAPTCHA_PROJECT_ID"]}/assessments?key=#{ENV["RECAPTCHA_API_KEY"]}")
    request_data = {
      event: {
        token: token,
        siteKey: ENV["RECAPTCHA_SITE_KEY"],
        expectedAction: "submit",
      }
    }

    response = Net::HTTP.post(uri, request_data.to_json, "Content-Type" => "application/json; charset=utf-8")
    json = JSON.parse(response.body)
    if json['tokenProperties']['valid'] == true && json['tokenProperties']['action'] == "submit"
      @kit_request.recaptcha_score = json['score']
      true
    else
      false
    end
  end

  def render_confirmation
    filename = Rails.root.join("tmp/cache/confirmation_#{I18n.locale}.html")
    if File.exist?(filename)
      render file: filename, layout: false
    else
      html = render_to_string :confirmation
      if ENV["CACHE_CONFIRMATION"] == "true"
        File.open(filename, "wb") do |file|
          file << html
        end
      end
      render html: html
    end
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
      :zip_code,
      :js_smarty_status
    )
  end
end
