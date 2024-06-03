
namespace :db do
  desc "Backfill order_items_count for products"
  task backfill_order_items_count: :environment do
    Product.find_each do |product|
      Product.reset_counters(product.id, :order_items)
    end
  end
end
