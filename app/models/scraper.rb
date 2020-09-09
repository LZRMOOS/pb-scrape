require 'nokogiri'
require 'open-uri'
# require 'pry'

class Scraper
  PB_LARGE_ENDURO_URL = 'https://www.pinkbike.com/buysell/list/?location=194-*-*&category=2,75&price=1000..4500&year=2021,2020&framesize=23,27,34,35,36,30,31,47&wheelsize=11,10'

  def scrape_listing_urls
    listing_urls = []
    html = open(PB_LARGE_ENDURO_URL)
    doc = Nokogiri::HTML(html)

    listings = doc.css('.filtered-search-results').css('.bsitem').css('a')

    listings.each do |l|
      url = l.attribute('href').value
      next unless /https:\/\/www\.pinkbike\.com\/buysell\/\d{7}/ =~ url
      listing_urls << url
    end


    next_page_url = doc.css('.next-page').css('a').attribute('href').value
    unless next_page_url.empty?
      url = "https://www.pinkbike.com/buysell/list/#{next_page_url}"

      html = open(url)
      doc = Nokogiri::HTML(html)

      listings = doc.css('.filtered-search-results').css('.bsitem').css('a')

      listings.each do |l|
        url = l.attribute('href').value
        next unless /https:\/\/www\.pinkbike\.com\/buysell\/\d{7}/ =~ url
        listing_urls << url
      end
    end

    # binding.pry
    # exit!
    listing_urls
  end

  def scrape_listings(url_array)
    listings = []

    url_array.each do |url|
      html = open(url)
      doc = Nokogiri::HTML(html)

      title = doc.css('.buysell-title').text
      price = doc.css('.buysell-price').last.children[0].text.strip

      category = doc.css('.buysell-details-column').first.children[2].text.strip

      original_post_date = Date.parse(doc.css('.buysell-details-column').last.children[2].text.strip)
      last_repost_date = Date.parse(doc.css('.buysell-details-column').last.children[6].text.strip)
      sale_status = doc.css('.buysell-details-column').last.children[11].text.strip
      view_count = doc.css('.buysell-details-column').last.children[16].text.strip.to_i
      watch_count = doc.css('.buysell-details-column').last.children[20].text.strip.to_i

      next unless original_post_date > Time.new.to_date - 10

      params = {
        url: url,
        title: title,
        price: price,
        category: category,
        original_post_date: original_post_date,
        last_repost_date: last_repost_date,
        sale_status: sale_status,
        view_count: view_count,
        watch_count: watch_count
      }
      listings << params
      # listings
      # binding.pry
      # exit!
    end
    listings
  end
end

# scrape = Scraper.new
# listings = scrape.scrape_listings(scrape.scrape_listing_urls)

# listings.each do |l|
#   Listing.create!(l)
# end

