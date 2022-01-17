module ApplicationHelper
  def format_active_locale(locale_string)
    if locale_string.to_sym == I18n.locale
      content_tag "span", t("shared.languages.#{locale_string}")
    else
      link_to t("shared.languages.#{locale_string}"), root_path(locale: locale_string)
    end
  end

  def error_options(object, method)
    {
      "aria-invalid": errored?(object, method),
      "aria-describedby": errored?(object, method) ? accessible_error_id(object, method) : nil
    }
  end

  def errored?(object, method)
    object.errors[method].any?
  end

  def accessible_error_id(object, method)
    field_id(object, method, :error)
  end

  def accessible_errors(object, method, hidden = false, opts = {})
    opts[:hidden] = true if hidden

    if errored?(object, method) || hidden
      content_tag("div", tabindex: -1, class: "error-message", id: accessible_error_id(object, method), **opts) do
        object.errors[method].map { |message| message }.join("<br/>")
      end
    end
  end
end
