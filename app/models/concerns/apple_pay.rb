require 'httparty'
module ApplePay
  URL = 'https://buy.itunes.apple.com/verifyReceipt'
  SANDBOX_URL = 'https://sandbox.itunes.apple.com/verifyReceipt'
  extend self

  def detect_verify(receipt_data)
    r = verify(receipt_data)

    if r['status'] == 21007
      verify(receipt_data, true)
    else
      r
    end
  end

  def verify(receipt_data, sandbox = false)
    if sandbox
      url = SANDBOX_URL
    else
      url = URL
    end

    options = {
      body: { 'receipt-data' => receipt_data }.to_json
    }

    r = HTTParty.post(url, options)
    JSON.parse(r.body)
  end

end
