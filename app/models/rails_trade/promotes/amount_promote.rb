class AmountPromote < Promote

  def compute_amount(good, number, extra)
    amount = good.retail_price * number
    compute_charge(amount, extra)
  end

end
