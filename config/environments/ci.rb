require_relative "./production"

Rails.application.configure do
  config.assets.compile = true
  config.public_file_server.enabled = true

  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)
end
