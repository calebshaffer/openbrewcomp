# -*- coding: utf-8 -*-

class Order < ActiveRecord::Base

  has_and_belongs_to_many :entries
  belongs_to :entrant
  belongs_to :user

  # bleh ... rules
  # - all entries must bre for the same user and entrant, and match user and entrant for order
  # - order can not be set to is_paid=true if any entries were already paid, and all entries will be 
  #   set to is_paid=true if we're good here
  # - !!!

  validates_each :entries do |record, attr, value|
    value.map(&:user).reduce(&:==)
  end
  
  after_save do |order|
    if order.is_paid_changed? && order.is_paid
      order.entries.each do |entry|
        entry.is_paid = true
        entry.save!
      end
    end
  end

  def paypal_payment_details
    [
      {
        :OrderTotal => {
          :currencyID => "USD",
          :value => self.entries.map(&:fee).sum,
        },
        :PaymentDetailsItem => paypal_payment_details_item,
        :PaymentAction => "Sale"
      }
    ]
  end

  def paypal_payment_details_item
    self.entries.map do |entry|
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

  # verify all entries are unpaid and payment pays for all entries
  def verify_express_checkout_details(details)
    paid_registration_codes = details.payment_details.map {|d| d.payment_details_item }.flatten.map {|d| d.number.to_i }
    intersecting_entries = self.entries.select {|entry| paid_registration_codes.include?(entry.registration_code) }
    return intersecting_entries.count == self.entries.count && !self.entries.map(&:is_paid).any?
  end

end

