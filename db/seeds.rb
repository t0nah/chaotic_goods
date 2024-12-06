require 'httparty'
require 'faker'

# Clear existing products
# Product.destroy_all
# Category.destroy_all

# Fetch product data from the API
url = 'https://retoolapi.dev/BZXzuB/mrporter'
response = HTTParty.get(url)

if response.code == 200
  products_data = response.parsed_response

  # Create products using data from the API
  products_data.each do |product_data|
    Product.find_or_create_by!(
      name: product_data['description'],  # Using 'description' as the product name
      brand: product_data['brand'],        # 'brand' as the brand
      price: product_data['price_usd'],    # 'price_usd' as the product price
      category: Category.find_or_create_by(name: product_data['type'])  # Create or find the category
    )
  end

  puts "Created #{Product.count} products!"
else
  puts "Failed to fetch data from API. Response code: #{response.code}"
end
#
