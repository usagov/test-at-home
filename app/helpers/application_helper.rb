module ApplicationHelper
  def format_active_locale(locale_string)
    if locale_string.to_sym == I18n.locale
      content_tag "span", t("shared.languages.#{locale_string}")
    else
      link_to t("shared.languages.#{locale_string}"), root_path(locale: locale_string)
    end
  end
end
