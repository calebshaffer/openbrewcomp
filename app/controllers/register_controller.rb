# -*- coding: utf-8 -*-

class RegisterController < ApplicationController

  before_filter :get_registration_status
  before_filter :login_required, :only => [ :online, :judge_confirmation ],
                                 :if => :is_registration_open?

  # If the start of registration is less than 2 weeks away,
  # tell us how much time remains before registration opens.
  COUNTDOWN_PERIOD = 2.weeks

  def online
    registration_start_time_utc = [ competition_data.entry_registration_start_time_utc,
                                    competition_data.judge_registration_start_time_utc ].compact.min
    if competition_data.is_registration_future? &&
      Time.now.utc.between?(registration_start_time_utc - COUNTDOWN_PERIOD,
                            registration_start_time_utc)
      @time_to_go = TimeInterval.difference_in_words(Time.now.utc, registration_start_time_utc)
    elsif competition_data.is_registration_open?
      @auto_open_judge = flash[:auto_open_judge]
      @auto_edit_judge_id = flash[:auto_edit_judge_id]
      flash.keep#(:warning)
    end
    @entry_count = current_user.entries.count
  end

  def complete
    @entry_count = current_user.entries.count
    @entry_id = current_user.id
  end

  def paypal_checkout
    entries = current_user.entries.unpaid

    payment_details = entries.map do |entry|
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

    total = entries.map(&:fee).sum

    api = PayPal::SDK::Merchant::API.new
    set_express_checkout = api.build_set_express_checkout({
      # :Version => "104.0",
      :SetExpressCheckoutRequestDetails => {
        :ReturnURL => registration_paypal_complete_url, 
        :CancelURL => registration_complete_url,
        :PaymentDetails => [
          {
            :OrderTotal => {
              :currencyID => "USD",
              :value => total,
            },
            :PaymentDetailsItem => payment_details,
            :PaymentAction => "Sale"
          }
        ]
      }
    })

    set_express_checkout_response = api.set_express_checkout(set_express_checkout)
    express_checkout_token = set_express_checkout_response.token
    redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#{express_checkout_token}"
  end

  def paypal_complete
    api = PayPal::SDK::Merchant::API.new
    get_express_checkout_details = api.build_get_express_checkout_details({
      # :Version => "104.0",
      :Token => params[:token]
    })

    get_express_checkout_details_response = api.get_express_checkout_details(get_express_checkout_details)

    paid_registration_codes = get_express_checkout_details_response.
      get_express_checkout_details_response_details.
      payment_details.map {|d| d.payment_details_item }.flatten.
      map {|d| d.number.to_i }

    paid_entries = current_user.entries.select {|e| paid_registration_codes.include? e.registration_code }

    # if all registration codes are present in current user's unpaid list
    if paid_entries.count == paid_registration_codes.count && paid_entries.map {|e| !e.is_paid }.all?
      # TODO: factor this ... 
      payer_id = get_express_checkout_details_response.
        get_express_checkout_details_response_details.
        payer_info.
        payer_id

      # puts get_express_checkout_details_response.inspect  
      do_express_checkout_payment = api.build_do_express_checkout_payment({
        # :Version => "104.0",
        :DoExpressCheckoutPaymentRequestDetails => {
          :Token => params[:token],
          :PayerID => payer_id,
          :PaymentDetails => {
            :OrderTotal => {
              :currencyID => "USD",
              :value => paid_entries.map(&:fee).sum
            },
          },
        }
      })
      do_express_checkout_payment_response = api.do_express_checkout_payment(do_express_checkout_payment)

      if do_express_checkout_payment_response.ack == "Success"
        # yay!!!!
        paid_entries.each do |entry|
          entry.is_paid = true
          entry.save!
        end
      else
        raise "payment confirmation failed"
      end
    else
      raise "possible double payment"
    end
  end

  def judge_confirmation
    if competition_data.is_registration_open?
      judge = Judge.find_by_access_key(params[:key])
      flash[:auto_open_judge] = true
      unless judge.nil?
        judge.update_attribute(:user_id, current_user.id)
        flash[:auto_edit_judge_id] = judge.id
      else
        flash[:warning] = 'Confirmation key was not found'
      end
    end
    redirect_to online_registration_path
  end

  def forms
    @competition_name = CompetitionData.instance.name
  end

  private

    def is_registration_open?
      @is_registration_open
    end

    def get_registration_status
      @registration_status        = competition_data.registration_status
      @is_registration_open       = competition_data.is_registration_open?
      @entry_registration_status  = competition_data.entry_registration_status
      @is_entry_registration_open = competition_data.is_entry_registration_open?
      @judge_registration_status  = competition_data.judge_registration_status
      @is_judge_registration_open = competition_data.is_judge_registration_open?
    end

    END_OF_TIME = Time.at(0x7fffffff).freeze  # The end of time as we know it
    def registration_time_remaining
      # If no end time is set, use a date "far" in the future -- we pick the
      # end of Unix time (2038-01-18T15:14:07Z) since anything beyond this
      # point causes Ruby to throw a TypeError in Date#-.
      ([ competition_data.entry_registration_end_time,
         competition_data.judge_registration_end_time].compact.max || END_OF_TIME) - Time.now.utc
    end

end
