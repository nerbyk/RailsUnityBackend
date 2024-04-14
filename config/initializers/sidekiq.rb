Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/schedule.yml"

    if File.exist?(schedule_file)
      schedule = YAML.load_file(schedule_file)

      Sidekiq::Cron::Job.load_from_hash!(schedule)
    end
  end

  Sidekiq::Options[:cron_poll_interval] = 5
end
