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
      @paypal_client = PaypalClient.new(:set,
        :complete_url => paypal_complete_url, 
        :cancel_url => paypal_cancel_url
      )
      
      if @paypal_client.set_express_checkout(@entries)
        redirect_to @paypal_client.set_express_checkout_redirect
      else
        flash[:error] = 'Error setting up paypal transaction'
        redirect_to online_registration_path
      end
    end
  end

  def complete
    # @entries = current_user.entries.unpaid # TODO: a better way to synchronize pending entries
    @paypal_client = PaypalClient.new(:do,
      :token => params[:token]
    )

    if @paypal_client.do_express_checkout
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