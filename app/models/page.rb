require 'base64'
require 'socket'
require 'net/http'
require 'uri'

class Page < ApplicationRecord
  attr_accessor :file

  validates :url,
    presence: true,
    format: /\A#{URI::regexp(%w(http https))}\z/

  after_initialize :after_initialize
  before_save :before_save
  after_save :after_save
  after_destroy :after_destroy

  def to_base64
    Base64.encode64(File.read(self.file))
  end

  def get_screenshot(url)
    screenshot_url = 'https://prickly-bose-5726.arukascloud.io/'
    Net::HTTP.post(URI.parse(screenshot_url), 'target=' + url).body
  end

  def get_source(url)
    Net::HTTP.get(URI.parse(url))
  end

  private
  def after_initialize
    if self.uuid.nil?
      self.uuid = SecureRandom.uuid
    end

    self.file = "#{Rails.root}/db/images/#{uuid}.png"
  end

  def before_save
    @is_new_record = self.new_record?

    uri = URI.parse(self.url)
    self.ipaddr = Socket.getaddrinfo(uri.host, nil)[0][3]

    self.source = self.get_source(self.url)
  end

  def after_save
    if @is_new_record
      screenshot = self.get_screenshot(self.url)
      File.open(self.file, 'wb') do |f|
        f.write(Base64.decode64(screenshot))
      end
    end
  end

  def after_destroy
    File.delete(self.file)
  end
end
