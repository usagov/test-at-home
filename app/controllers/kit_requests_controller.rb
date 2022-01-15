class KitRequestsController < ApplicationController
  def new
    @kit_request = KitRequest.new
    response.set_header("Cache-Control", "public, max-age=#{ENV["CACHE_FORM_AGE"]}")
  end

  def create
    @kit_request = KitRequest.new(kit_request_params)

    if @kit_request.save
      render :confirmation
    else
      render :new
    end
  end

  private

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
