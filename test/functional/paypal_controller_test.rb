# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../test_helper'

class PaypalControllerTest < ActionController::TestCase

  def test_show
    # PaypalClient.any_instance.stubs(:set_express_checkout).returns(true)
    # PaypalClient.any_instance.stubs(:set_express_checkout_token).returns("token")

    login_as(:testuser1)

    get :index
    assert_response :redirect
    assert_redirected_to "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=token"
  end

  def test_show_error
    PaypalClient.any_instance.stubs(:set_express_checkout).returns(nil)

    login_as(:testuser1)

    get :index
    assert_response :redirect
    assert_redirected_to online_registration_path
    assert_equal flash[:error], 'Error setting up paypal transaction'
  end

end