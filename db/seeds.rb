# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'

# Create admin user
admin = User.create!(
  email: 'john@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

# Create regular users
users = []
5.times do |i|
  users << User.create!(
    email: "user#{i+1}@example.com",
    password: 'password123',
    password_confirmation: 'password123'
  )
end

# Create products
products = [
  {
    name: 'Premium Beach Umbrella',
    description: 'Large 7ft beach umbrella with UV protection and sand anchor.',
    price: 49.99,
    stock: 10,
    image_url: 'https://images.unsplash.com/photo-1533745848184-3db07256e163?w=800&auto=format&fit=crop'
  },
  {
    name: 'Deluxe Beach Chair',
    description: 'Comfortable folding chair with cup holder and storage pouch.',
    price: 79.99,
    stock: 15,
    image_url: 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800&auto=format&fit=crop'
  },
  {
    name: 'Pro Surfboard',
    description: 'High-performance surfboard for all skill levels.',
    price: 399.99,
    stock: 8,
    image_url: 'https://images.unsplash.com/photo-1531722569936-825d3dd91b15?w=800&auto=format&fit=crop'
  },
  {
    name: 'Beach Tent Cabana',
    description: 'Pop-up beach tent with UV protection and ventilation.',
    price: 89.99,
    stock: 20,
    image_url: 'https://images.unsplash.com/photo-1623894433255-947c0a45b211?w=800&auto=format&fit=crop'
  },
  {
    name: 'Waterproof Beach Blanket',
    description: 'Sand-free, waterproof blanket perfect for beach days.',
    price: 29.99,
    stock: 25,
    image_url: 'https://images.unsplash.com/photo-1517398823963-c2dc6fc3e837?w=800&auto=format&fit=crop'
  },
  {
    name: 'Luxury Beach Tote',
    description: 'Spacious waterproof beach bag with cooler compartment',
    price: 45.99,
    stock: 30,
    image_url: 'https://images.unsplash.com/photo-1535891169584-75bcaf12e3c7?w=800&auto=format&fit=crop'
  },
  {
    name: 'Beach Volleyball Set',
    description: 'Professional grade volleyball with portable net',
    price: 59.99,
    stock: 12,
    image_url: 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=800&auto=format&fit=crop'
  },
  {
    name: 'Premium Snorkel Set',
    description: 'Anti-fog mask with dry top snorkel and fins',
    price: 79.99,
    stock: 18,
    image_url: 'https://images.unsplash.com/photo-1601007210190-c9f1c9c3c2ae?w=800&auto=format&fit=crop'
  },
  {
    name: 'Beach Cart Wheeler',
    description: 'Collapsible wagon for easy beach transport',
    price: 89.99,
    stock: 15,
    image_url: 'https://images.unsplash.com/photo-1596464716127-f2a82984de30?w=800&auto=format&fit=crop'
  },
  {
    name: 'Kids Sand Toy Set',
    description: 'Complete set with bucket, shovel, and sand molds',
    price: 24.99,
    stock: 40,
    image_url: 'https://images.unsplash.com/photo-1558432855-6dafa5952a64?w=800&auto=format&fit=crop'
  },
  {
    name: 'Beach Hammock',
    description: 'Portable hammock with stand for beach relaxation',
    price: 119.99,
    stock: 10,
    image_url: 'https://images.unsplash.com/photo-1580077394770-4820da945e88?w=800&auto=format&fit=crop'
  },
  {
    name: 'Waterproof Speaker',
    description: 'Bluetooth beach speaker with 20hr battery life',
    price: 69.99,
    stock: 25,
    image_url: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=800&auto=format&fit=crop'
  },
  {
    name: 'Beach Games Bundle',
    description: 'Set includes frisbee, paddle ball, and ring toss',
    price: 39.99,
    stock: 20,
    image_url: 'https://images.unsplash.com/photo-1533591380348-14193f1de18f?w=800&auto=format&fit=crop'
  },
  {
    name: 'Sun Shelter XL',
    description: 'Extra large beach canopy with sand anchors',
    price: 149.99,
    stock: 8,
    image_url: 'https://images.unsplash.com/photo-1621463819919-38c9922a3c76?w=800&auto=format&fit=crop'
  },
  {
    name: 'Beach Cooler Backpack',
    description: 'Insulated backpack keeps drinks cold for 24hrs',
    price: 54.99,
    stock: 30,
    image_url: 'https://images.unsplash.com/photo-1581598017943-3d54b7a84f34?w=800&auto=format&fit=crop'
  }
]

created_products = products.map do |product_data|
  image_url = product_data.delete(:image_url)
  product = Product.create!(product_data)

  begin
    # Download and attach the image
    downloaded_image = URI.open(image_url)
    product.image.attach(
      io: downloaded_image,
      filename: "#{product.name.parameterize}.jpg",
      content_type: 'image/jpeg'
    )
  rescue OpenURI::HTTPError => e
    puts "Failed to download image for #{product.name}: #{e.message}"
  end

  product
end

# Create carts for users
users.each do |user|
  cart = Cart.create!(user: user)
  # Add random products to cart
  2.times do
    CartItem.create!(
      cart: cart,
      product: created_products.sample,
      quantity: rand(1..3)
    )
  end
end

# Create some messages between users
users.each do |user|
  2.times do
    recipient = (users + [ admin ]).reject { |u| u == user }.sample
    Message.create!(
      user: user,
      recipient: recipient,
      content: [ "Hi, is this item still available?", "When will this be back in stock?", "Thanks for the quick delivery!" ].sample
    )
  end
end
