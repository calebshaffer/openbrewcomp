# -*- coding: utf-8 -*-

class PaypalController < ApplicationController

  before_filter :login_required, :only => [:show] # should complete and cancel required login?
  # before_filter :initialize_paypal_client

  def index
    @entries = current_user.entries.unpaid
    if @entries.empty? 
      flash[:notice] = 'No entries to pay for'
      redirect_to online_registration_path
    else
      @paypal_client = initialize_paypal_client
      
      if @paypal_client.set_express_checkout(@entries)
        redirect_to @paypal_client.set_express_checkout_redirect
      else
        flash[:error] = 'Error setting up paypal transaction'
        redirect_to online_registration_path
      end
    end
  end

  def complete
    @paypal_client = initialize_paypal_client

  end

  def cancel
  end

  def notify
  end

  private
    def initialize_paypal_client
      PaypalClient.new(
        :complete_url => paypal_complete_url, 
        :cancel_url => registration_complete_url
      )
    end

  # def complete
  #   api = PayPal::SDK::Merchant::API.new
  #   get_express_checkout_details = api.build_get_express_checkout_details({
  #     # :Version => "104.0",
  #     :Token => params[:token]
  #   })

  #   get_express_checkout_details_response = api.get_express_checkout_details(get_express_checkout_details)

  #   details = paid_registration_codes = get_express_checkout_details_response.
  #     get_express_checkout_details_response_details

  #   paid_registration_codes = get_express_checkout_details_response.
  #     get_express_checkout_details_response_details.
  #     payment_details.map {|d| d.payment_details_item }.flatten.
  #     map {|d| d.number.to_i }

  #   paid_entries = current_user.entries.select {|e| paid_registration_codes.include? e.registration_code }

  #   # if all registration codes are present in current user's unpaid list
  #   if paid_entries.count == paid_registration_codes.count && paid_entries.map {|e| !e.is_paid }.all?
  #     # TODO: factor this ... 
  #     payer_id = get_express_checkout_details_response.
  #       get_express_checkout_details_response_details.
  #       payer_info.
  #       payer_id


  #     debugger
  #     # puts get_express_checkout_details_response.inspect  
  #     do_express_checkout_payment = api.build_do_express_checkout_payment({
  #       # :Version => "104.0",
  #       :DoExpressCheckoutPaymentRequestDetails => {
  #         :Token => params[:token],
  #         :PayerID => payer_id,
  #         :PaymentDetails => {
  #           :OrderTotal => {
  #             :currencyID => "USD",
  #             :value => paid_entries.map(&:fee).sum
  #           },
  #         },
  #       }
  #     })
  #     do_express_checkout_payment_response = api.do_express_checkout_payment(do_express_checkout_payment)

  #     paypal = Paypal.new({
  #       :entries => paid_entries,
  #       :payer_id => details.PayerInfo.PayerID,
  #       :transaction_id => details.PaymentRequestInfo[0].TransactionId,
  #     })

  #     puts paypal.inspect
  #     paypal.save!

  #     # if do_express_checkout_payment_response.ack == "Success"
  #     #   # yay!!!!
  #     #   paid_entries.each do |entry|
  #     #     entry.is_paid = true
  #     #     entry.save!
  #     #   end
  #     # else
  #     #   raise "payment confirmation failed"
  #     # end
  #   else
  #     raise "possible double payment"
  #   end
  # end

end