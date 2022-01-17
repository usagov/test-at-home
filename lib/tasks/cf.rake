namespace :cf do
  desc "Only run on the first application instance"
  task :on_first_instance do
    instance_index = Integer(ENV["CF_INSTANCE_INDEX"])
    exit(0) unless instance_index == 0

    # only first instance if this is the "main" feature app
    feature_name = ENV["FEATURE_NAME"]
    main_feature_app = feature_name == "prod" || feature_name == "stage"
    exit(0) unless main_feature_app
  rescue
    exit(0)
  end
end
