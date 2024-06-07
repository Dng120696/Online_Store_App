# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Admin.create(firstname: 'Patrick',lastname: 'Nebab', email: 'admin@admin.com',password:'password123')
admin = Admin.first
user = User.create(firstname: 'Pat',lastname: 'Nebab', email: 'user@user.com',password:'password123',
 address_attributes:  {
  street: '123 Tugue Street',
  city: 'Tuguegarao',
  state_or_province: 'Cagayan',
  country: 'Philippines',
  zip_code: '3519'
})
user.skip_confirmation!
admin.categories.create(title:"Best Seller")
admin.categories.create(title:"New Releases")
admin.categories.create(title:"Books")
admin.categories.create(title:"Clothes")
admin.categories.create(title:"Computers")
admin.categories.create(title:"Fashion")
admin.categories.create(title:"Health")
admin.categories.create(title:"Pharmacy")
admin.categories.create(title:"Toys & Games")
