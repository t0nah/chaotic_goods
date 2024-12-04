require 'httparty'
require 'nokogiri'
load 'lib/scrape.rb'

products = scrape_farfetch(50) # This would call the scraper and fetch data
products.each do |product|
  Product.create!(
    name: product[:name],
    brand: product[:brand],
    price: product[:price],
    category: Category.find_or_create_by(name: product[:category])
  )
end
