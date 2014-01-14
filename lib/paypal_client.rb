# -*- coding: utf-8 -*-

class PaypalClient 

  def initialize #(method, args)
    @api = PayPal::SDK::Merchant::API.new
  end

  def set_express_checkout(payment_details, complete_url, cancel_url)
    set_express_checkout = @api.build_set_express_checkout({
      :SetExpressCheckoutRequestDetails => {
        :ReturnURL => complete_url,
        :CancelURL => cancel_url,
        :PaymentDetails => payment_details
      }
    })

    response = @api.set_express_checkout(set_express_checkout)
    if response && response.token
      return response.token
    else
      return nil
    end
  end

  def get_express_checkout_details(token)
    @api.get_express_checkout_details @api.build_get_express_checkout_details({
      :Token => token
    })
  end

  def do_express_checkout_payment(order)
    token = order.paypal_express_checkout_token
    payer_id = order.paypal_payer_id

    do_express_checkout_payment = @api.build_do_express_checkout_payment({
      :DoExpressCheckoutPaymentRequestDetails => {
        :Token => token,
        :PayerID => payer_id,
        :PaymentDetails => order.paypal_payment_details
      }
    })

    response = @api.do_express_checkout_payment(do_express_checkout_payment)
    if response && response.ack == "Success"
      return response.do_express_checkout_payment_response_details.payment_info[0].transaction_id
    else
      return nil
    end
  end

end
