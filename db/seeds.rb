require 'httparty'

# Define the API endpoint
api_url = 'https://fakestoreapi.com/products'

# Get the data from the API
response = HTTParty.get(api_url)
products = JSON.parse(response.body)

# Iterate through the products and create entries in the database
products.each do |product|
  # Find or create the category
  category = Category.find_or_create_by(name: product['category'])

  # Only create a product if it doesn't already exist
  Product.find_or_create_by(name: product['title']) do |p|
    p.price = product['price']
    p.description = product['description']
    p.brand = product['brand'] || 'Unknown'  # If brand is not provided, set it as 'Unknown'
    p.category = category  # Assign the category object to the product
    p.image = product['image']
  end
end

puts "Database seeded with products!"
