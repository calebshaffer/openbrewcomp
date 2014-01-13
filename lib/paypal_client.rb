# -*- coding: utf-8 -*-

class PaypalClient 

  def initialize(args)
    @complete_url = args[:complete_url]
    @cancel_url = args[:cancel_url]
    @api = PayPal::SDK::Merchant::API.new
  end

  def set_express_checkout_payment_details(entries)
    entries.map do |entry|
      {
        :Name => entry.name,
        :Description => entry.style.category_and_name,
        :Number => entry.registration_code,
        :Amount => {
          :currencyID => "USD",
          :value => entry.fee
        },
      }
    end
  end

  def set_express_checkout(entries)
    set_express_checkout = @api.build_set_express_checkout({
      :SetExpressCheckoutRequestDetails => {
        :ReturnURL => @complete_url,
        :CancelURL => @cancel_url,
        :PaymentDetails => [
          {
            :OrderTotal => {
              :currencyID => "USD",
              :value => entries.map(&:fee).sum,
            },
            :PaymentDetailsItem => set_express_checkout_payment_details(entries),
            :PaymentAction => "Sale"
          }
        ]
      }
    })
    @express_checkout_response = @api.set_express_checkout(set_express_checkout)
    return @express_checkout_response.success?
  end

  def set_express_checkout_token
    @set_express_checkout_response.token
  end

  def set_express_checkout_redirect
    token = set_express_checkout_token
    "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#{token}"
  end

end
