class KitRequestsController < ApplicationController
  def new
    @kit_request = KitRequest.new
    response.set_header("Cache-Control", "public, max-age=#{ENV["CACHE_FORM_AGE"]}")
  end

  def create
    @kit_request = KitRequest.new(kit_request_params)

    if @kit_request.save
      ::NewRelic::Agent.increment_metric("Custom/Submission/success")
      render_confirmation
    else
      ::NewRelic::Agent.increment_metric("Custom/Submission/error")
      render :new, formats: :html
    end
  end

  private

  def render_confirmation
    filename = Rails.root.join("tmp/cache/confirmation_#{I18n.locale}.html")
    if File.exist?(filename)
      render file: filename, layout: false
    else
      html = render_to_string :confirmation, formats: :html
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
      :js_smarty_status,
      :recaptcha_token
    )
  end
end
