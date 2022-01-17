class ErrorsController < ApplicationController
  def not_found
    render_not_found
  end

  def internal_server_error
    render_confirmation
  end

  private

  def render_not_found
    filename = Rails.root.join("tmp/cache/not_found_#{I18n.locale}.html")
    if File.exist?(filename)
      render file: filename, layout: false, status: 404
    else
      html = render_to_string :not_found
      if ENV["CACHE_ERRORS"] == "true"
        File.open(filename, "wb") do |file|
          file << html
        end
      end
      render status: 404
    end
  end

  def render_internal_server_error
    filename = Rails.root.join("tmp/cache/internal_server_error_#{I18n.locale}.html")
    if File.exist?(filename)
      render file: filename, layout: false, status: 500
    else
      html = render_to_string :internal_server_error
      if ENV["CACHE_ERRORS"] == "true"
        File.open(filename, "wb") do |file|
          file << html
        end
      end
      render status: 500
    end
  end
end
