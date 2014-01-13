# -*- coding: utf-8 -*-

class PaypalClient 

  def initialize(method, args)
    @method = method

    @complete_url = args[:complete_url]
    @cancel_url = args[:cancel_url]

    @token = args[:token]

    @api = PayPal::SDK::Merchant::API.new
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
    @set_express_checkout_response = @api.set_express_checkout(set_express_checkout)
    return @set_express_checkout_response.success?
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

  def set_express_checkout_token
    @set_express_checkout_response.token
  end

  def set_express_checkout_redirect
    token = set_express_checkout_token
    "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#{token}"
  end

  def do_express_checkout
    details = get_express_checkout_details.get_express_checkout_details_response_details
    
    if order = get_express_checkout_details_get_order(details)
      payer_id = get_express_checkout_details_payer_id(details)
      total = order.entries.map(&:fee).sum

      @do_express_checkout_payment_response = do_express_checkout_payment(@token, payer_id, total)

      if @do_express_checkout_payment_response.ack == "Success"
        # if transaction was successful, get the details again and save the transaction_id
        details = get_express_checkout_details.get_express_checkout_details_response_details
        order.paypal_transaction_id = get_express_checkout_transaction_id(details)
      end
      order.save
    end
  end
  
  def get_express_checkout_details
    get_express_checkout_details = @api.build_get_express_checkout_details({
      :Token => @token
    })
    @get_express_checkout_details_response = @api.get_express_checkout_details(get_express_checkout_details)
  end
  
  def get_express_checkout_details_get_paid_entries(details)
    # sift through response for entry_id's
    payment_details = details.payment_details
    # map payment details to the registration codes we passed
    paid_registration_codes = payment_details.map {|d| d.payment_details_item }.flatten.map {|d| d.number.to_i }
    # modulo 10000 gets entry.id ... this is a bit of a hack
    paid_entry_ids = paid_registration_codes.map {|c| c % 10000}
    # get the entries ... would be nice to use dependency injection to populate this in some way
    # so that we could filter by current user more easily
    entries = Entry.all(:conditions => ["id in (?)", paid_entry_ids])
    # verify that the entries have not yet been paid
    if paid_registration_codes.count == entries.count && !entries.map(&:is_paid).any?
      return entries
    else 
      return nil
    end
  end
  
  def get_express_checkout_details_get_order(details)
    if paid_entries = get_express_checkout_details_get_paid_entries(details)
      return Order.new(
        :paypal_transaction_id => get_express_checkout_transaction_id(details),
        :paypal_payer_id => get_express_checkout_details_payer_id(details),
        :entries => paid_entries
      )
    else
      return nil
    end
  end

  def get_express_checkout_details_payer_id(details)
    details.payer_info.payer_id
  end

  def get_express_checkout_transaction_id(details)
    details.PaymentRequestInfo[0].TransactionId
  end

  def do_express_checkout_payment(token, payer_id, value)
    do_express_checkout_payment = @api.build_do_express_checkout_payment({
      :DoExpressCheckoutPaymentRequestDetails => {
        :Token => token,
        :PayerID => payer_id,
        :PaymentDetails => {
          :OrderTotal => {
            :currencyID => "USD",
            :value => value
          }
        }
      }
    })
    return @api.do_express_checkout_payment(do_express_checkout_payment)
  end

end
