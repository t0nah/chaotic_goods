require 'httparty'
require 'faker'

# Clear existing products
Product.destroy_all
Category.destroy_all

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

# Faker
categories = ["Clothing", "Accessories"]
category_records = categories.map do |category_name|
  Category.create!(name: category_name)
end

# Define a list of clothing and accessory-related brands
brands = ["Dior", "Chanel", "Gucci", "Louis Vuitton", "Prada", "Balenciaga", "Versace", "Burberry"]

100.times do
  category = category_records.sample

  # Generate a random product name
  product_name = "#{Faker::Commerce.material} #{brands.sample} #{Faker::Commerce.product_name}"
  product_type = category.name.downcase

  # Create a random image URL based on the product type
  image_url = "https://source.unsplash.com/200x200/?#{product_type},#{Faker::Commerce.product_name.downcase}"

  Product.find_or_create_by!(
    name: product_name,
    price: Faker::Commerce.price(range: 100..2000),
    brand: brands.sample,
    category: category,  # Set the category
    category_id: category.id,
    image: image_url
  )
end

puts "Seeded #{Category.count} categories and #{Product.count} products!"