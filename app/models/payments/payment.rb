class Payment < ApplicationRecord
  has_many :payment_orders, dependent: :destroy
  has_many :orders, through: :payment_orders

end


=begin

create_table "payments", force: :cascade do |t|
  t.integer "user_id",     limit: 4
  t.integer "order_id",    limit: 4
  t.float   "total_price", limit: 24
end

=end