class UrlWorker
  include Sidekiq::Worker

  def perform_async(*args)
    # Do something
  end
end
