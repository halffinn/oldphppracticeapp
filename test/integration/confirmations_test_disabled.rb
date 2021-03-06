require 'test_helper'
class ConfirmationsTest < ActionController::IntegrationTest

  setup do
    without_access_control do
      @user = Factory(:user, :confirmed_at => nil)
    end
  end

  should "create new confirmation token (xml)" do
    post '/users/confirmation.xml', {:email => @user.email}
    assert_response(200)
    assert_equal 'application/xml', @response.content_type
    assert_tag 'rsp', :child => { :tag => "stat", :content => "ok" }
  end

  should "create new confirmation token (json)" do
    post '/users/confirmation.json', {:email => @user.email}
    assert_response(200)
    assert_equal 'application/json', @response.content_type
    json = ActiveSupport::JSON.decode(response.body)
    assert_kind_of Hash, json
    assert_equal "ok", json['stat']
  end

  should "not create new confirmation token (xml)" do
    post '/users/confirmation.xml', {:email => Faker::Internet.email}
    assert_response(200)
    assert_equal 'application/xml', @response.content_type
    assert_tag 'rsp', :child => { :tag => "stat", :content => "fail" }
    assert_tag 'err', :child => { :tag => "email", :content => "106" }
  end

  should "confirm account (xml)" do
    get '/users/confirmation.xml', {:confirmation_token => @user.confirmation_token}
    assert_response(200)
    assert_equal 'application/xml', @response.content_type
    assert_tag 'rsp', :child => { :tag => "stat", :content => "ok" }
    assert_tag 'rsp', :child => { :tag => 'authentication_token', :content => @user.authentication_token }
  end

  should "confirm account (json)" do
    get '/users/confirmation.json', {:confirmation_token => @user.confirmation_token}
    assert_response(200)
    assert_equal 'application/json', @response.content_type
    json = ActiveSupport::JSON.decode(response.body)
    assert_kind_of Hash, json
    assert_equal "ok", json['stat']
    assert_equal @user.authentication_token, json['authentication_token']
  end

  should "no confirm account (xml)" do
    get '/users/confirmation.xml', {:confirmation_token => "invalid-token"}
    assert_response(401)
    assert_equal 'application/xml', @response.content_type
    assert_tag 'rsp', :child => { :tag => "stat", :content => "fail" }
    assert_tag 'err', :child => { :tag => "confirmation_token", :content => "103" }
  end

end