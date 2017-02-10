require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'uri'

class Imget

  def initialize(url)
    @url = URI(httpify(url))
  end

  def request_url
    response = HTTParty.get(@url.to_s)
    response.body
  end

  def get_images
    page   = Nokogiri::HTML(request_url)
    images = []

    page.css('img').each do |img|
      images.push(image_address(img['src']))
    end

    images
  end

  def httpify(url)
    if url.start_with? 'http://'
      url
    elsif url.start_with? 'https://'
      url
    else
      "http://#{url}"
    end
  end

  def image_address(image)
    if image.start_with? '//'
      @url.scheme + ':' + image
    elsif image.start_with? '/'
      @url.scheme + '://' + @url.host + image
    else
      image
    end
  end

end
