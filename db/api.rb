require 'httparty'
require 'open-uri'

url = 'https://fakestoreapi.com/products'
response = HTTParty.get(url)
products = JSON.parse(response.body)

products.each do |product|
  name = product['name']
  price = product['price']
  category_name = product['category']
  image_url = product['image'] # Image URL provided by the API

  category_record = Category.find_or_create_by(name: category_name)

  # Create the product without attaching the image first
  new_product = Product.new(name: name, price: price, category: category_record)

  # Attach the image if the URL is valid
  if image_url.present?
    begin
      downloaded_image = URI.open(image_url)
      new_product.image.attach(io: downloaded_image, filename: "#{name.parameterize}.jpg")
    rescue OpenURI::HTTPError => e
      puts "Error downloading image for product '#{name}': #{e.message}"
    end
  end

  new_product.save!
end
