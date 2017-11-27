class OrderItem < ApplicationRecord
  belongs_to :order, autosave: true, inverse_of: :order_items
  belongs_to :cart_item, optional: true
  belongs_to :good, polymorphic: true, optional: true
  belongs_to :provider, optional: true
  has_many :order_promotes, autosave: true

  composed_of :fee,
              class_name: 'PromoteFee',
              mapping: [['good_type', 'good_type'], ['good_id', 'good_id'], ['quantity', 'number']]

  after_initialize if: :new_record? do |oi|
    if cart_item
      self.good_type = cart_item.good_type
      self.good_id = cart_item.good_id
      self.quantity = cart_item.quantity
      self.amount = cart_item.fee.bulk_price
      #self.provider = cart_item.good.provider

      cart_item.serve.charges.each do |serve_charge|
        op = self.order_serves.build(charge_id: serve_charge.id, promote_id: serve_charge.promote_id, amount: serve_charge.subtotal)
        op.order = self.order
      end
      cart_item.promote.charges.each do |promote_charge|
        op = self.order_promotes.build(charge_id: promote_charge.id, promote_id: promote_charge.promote_id, amount: promote_charge.subtotal)
        op.order = self.order
      end
    end
  end

end

# :cart_item_id, :integer
# :good_id, :integer,     limit: 4
# :quantity, :float
# :unit, :string
# :number, :integer, limit: 4, default: 1
# :total_price, :decimal, limit: 24
# :order_at :datetime
# :payed_at :datetime



