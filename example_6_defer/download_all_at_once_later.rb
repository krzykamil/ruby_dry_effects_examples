# frozen_string_literal: true
require 'dry/effects'

class DownloadManager
  include Dry::Effects.Defer

  def initialize(number_of_files)
    @downloaded_files = []
    @number_of_files = number_of_files
  end

  def call
    @number_of_files.times.with_index do |index|
      later { download_and_save_file(index) }
    end
  end

  def download_and_save_file(index)
    puts "Downloading file from http://example.com/file#{index}.txt"
    # Simulate downloading and saving the file
    sleep(3)
    file_name = "Number_#{index}_file_#{Time.now.to_i}.txt"
    # Pseudo code for saving the file
    # File.write(file_name, "Contents of the downloaded file from http://example.com/file#{index}.txt")
    puts "Downloaded and saved file as #{file_name}"
    @downloaded_files << file_name
  end
end

class MyApplication
  # Three special values are also supported:
  # :io returns the global pool for long, blocking (IO) tasks
  # :fast returns the global pool for short, fast operations
  # :immediate returns the global ImmediateExecutor object
  include Dry::Effects::Handler.Defer(executor: :fast)

  def initialize
    @downloader = DownloadManager
  end

  def call(number_of_files)
    # defer tasks in @downloader will be run on the same thread
    # Defer is based on concurrent-ruby gem
    with_defer { @downloader.new(number_of_files).() }
    puts "Done with defering!"
    puts "App is continuing, doing its own thing... and meanwhile..."
    sleep 20
  end
end

MyApplication.new.(5)
