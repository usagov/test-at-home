class ApplicationController < ActionController::Base
  skip_forgery_protection

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:new_locale] || params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # This needs to be a class method for the devise controller to have access to it
  # See: http://stackoverflow.com/questions/12550564/how-to-pass-locale-parameter-to-devise
  def self.default_url_options
    {locale: I18n.locale}.merge(super)
  end
end
