# -*- coding: utf-8 -*-

class PaypalController < ApplicationController

  before_filter :login_required, :only => [:show] # should complete and cancel required login?

  def index
    entries = current_user.entries.unpaid
    if entries.empty? 
      flash[:notice] = 'No entries to pay for'
      redirect_to online_registration_path
    else
      order = Order.new(
        :user => current_user,
        #TODO: entrant?
        :entries => entries
      )
      paypal_client = PaypalClient.new
      if token = paypal_client.set_express_checkout(order.paypal_payment_details, paypal_complete_url, paypal_cancel_url)
        order.paypal_express_checkout_token = token
        order.save!
        redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#{token}"
      else
        flash[:error] = 'Error setting up paypal transaction'
        redirect_to online_registration_path
      end
    end
  end

  def complete
    order = Order.find_by_paypal_express_checkout_token(params[:token])
    order.paypal_payer_id = params[:PayerID]
    order.save!

    paypal_client = PaypalClient.new
    
    express_checkout_details_response = paypal_client.get_express_checkout_details(params[:token])
    details = express_checkout_details_response.get_express_checkout_details_response_details

    if order.verify_express_checkout_details(details) &&
      transaction_id = paypal_client.do_express_checkout_payment(order)
      
      order.paypal_transaction_id = transaction_id
      order.is_paid = true
      order.save!

      flash[:notice] = 'Successfully processed paypal transaction'
      redirect_to online_registration_path
    else
      flash[:error] = 'Error processing paypal transaction'
      redirect_to online_registration_path
    end
  end

  def cancel
    flash[:error] = "Paypal transaction cancelled"
    redirect_to registration_complete_url
  end

  def notify
  end

end