class Order < ApplicationRecord
  include ThePayment
  include TheRefund

  belongs_to :payment_strategy, optional: true
  belongs_to :buyer, class_name: '::Buyer', foreign_key: :buyer_id
  has_many :payment_orders, inverse_of: :order, dependent: :destroy
  has_many :payments, through: :payment_orders
  has_many :order_items, dependent: :destroy, autosave: true, inverse_of: :order
  has_many :refunds, dependent: :nullify
  has_many :order_promotes, autosave: true, inverse_of: :order

  accepts_nested_attributes_for :order_items

  scope :credited, -> { where(payment_strategy_id: PaymentStrategy.where.not(period: 0).pluck(:id)) }
  scope :to_pay, -> { where(payment_status: ['unpaid', 'part_paid']) }

  after_initialize if: :new_record? do |o|
    self.uuid = UidHelper.nsec_uuid('OD')

    cart_item_ids = order_items.map(&:cart_item_id)
    ps = PromoteService.new(cart_item_ids)
    ps.charges.each do |charge|
      self.order_promotes.build(charge_id: charge.id, promote_id: charge.promote_id, amount: charge.subtotal)
    end
  end

  enum payment_status: {
    unpaid: 0,
    part_paid: 1,
    all_paid: 2,
    refunding: 3,
    refunded: 4
  }

  def migrate_from_cart_items(cart_item_ids)
    cart_items = CartItem.where(id: cart_item_ids)
    cart_items.each do |cart_item|
      self.order_items.build cart_item_id: cart_item.id, good_type: cart_item.good_type, good_id: cart_item.good_id, quantity: cart_item.quantity
    end
  end

  def promote_amount
    order_promotes.sum(:amount)
  end

end
