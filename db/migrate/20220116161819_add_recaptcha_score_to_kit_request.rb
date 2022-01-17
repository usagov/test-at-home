class AddRecaptchaScoreToKitRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :kit_requests, :recaptcha_score, :decimal, default: -1
  end
end
