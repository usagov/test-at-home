class ErrorsController < ApplicationController
  def not_found
    render_not_found
  end

  def internal_server_error
    render_internal_server_error
  end

  private

  # customize switch_locale for exception handling
  def switch_locale(&action)
    if request.env["action_dispatch.original_path"] =~ /\A\/(en|es|zh)\//
      I18n.with_locale($1, &action)
    else
      super
    end
  end

  def render_not_found
    filename = Rails.root.join("tmp/cache/not_found_#{I18n.locale}.html")
    if File.exist?(filename)
      render file: filename, layout: false, status: 404
    else
      html = render_to_string :not_found, formats: :html
      if ENV["CACHE_ERRORS"] == "true"
        File.open(filename, "wb") do |file|
          file << html
        end
      end
      render html: html, status: 404
    end
  end

  def render_internal_server_error
    filename = Rails.root.join("tmp/cache/internal_server_error_#{I18n.locale}.html")
    if File.exist?(filename)
      render file: filename, layout: false, status: 500
    else
      html = render_to_string :internal_server_error, formats: :html
      if ENV["CACHE_ERRORS"] == "true"
        File.open(filename, "wb") do |file|
          file << html
        end
      end
      render html: html, status: 500
    end
  end
end
