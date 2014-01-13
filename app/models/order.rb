# -*- coding: utf-8 -*-

class Order < ActiveRecord::Base
  has_and_belongs_to_many :entries

  after_save do |order|
    if order.paypal_transaction_id
      order.entries.each do |entry|
        entry.is_paid = true
        entry.save
      end
    end
  end

end

