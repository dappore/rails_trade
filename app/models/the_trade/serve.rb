class Serve < ApplicationRecord
  include GoodAble
  attr_accessor :price

  has_many :charges, class_name: 'ServeCharge', dependent: :delete_all

  scope :verified, -> { where(verified: true) }
  scope :special, -> { where(verified: true, overall: false) }
  scope :overall, -> { where(verified: true, overall: true) }

  after_commit :delete_cache, on: [:create, :destroy]
  #after_update_commit :delete_cache, if: -> { sequence_changed? }

  enum scope: {
    'total': 'total',
    'single': 'single'
  }

  def compute_price(amount, extra = {})
    query = { 'min-lte': amount.to_d, 'max-gt': amount.to_d }.merge(extra)
    charge = self.charges.default_where(query).first
    charge.subtotal = charge.final_price(amount) if charge
    charge
  end

end

# :start_at, :datetime
# :finish_at, :datetime