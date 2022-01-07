class KitRequestsController < ApplicationController
  def new
    @kit_request = KitRequest.new
  end

  def create
    @kit_request = KitRequest.new(kit_request_params)

    if @kit_request.save
      redirect_to kit_request_confirmation_path
    else
      render :new
    end
  end

  def confirmation
  end

  private

  def kit_request_params
    params.require(:kit_request).permit(:full_name, :address, :email, :phone_number)
  end
end
