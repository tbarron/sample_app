require 'spec_helper'

describe "Users" do
  describe "register" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit register_path
          fill_in "Name", :with => ""
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          fill_in "Password confirmation", :with => ""
          click_button "Register"
          response.should render_template('users/new')
          response.should have_selector("div", :id => "error explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit register_path
          fill_in "Name", :with => "Example User"
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "Password confirmation", :with => "foobar"
          click_button "Register"
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "Sign In/Out" do
    describe "failure" do
      it "should not sign a user in" do
        integration_sign_in(nil)
        response.should have_selector("div.flash.error", 
                                      :content => "Invalid") 
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        integration_sign_in(Factory(:user))
        controller.should be_signed_in
        click_link "Sign Out"
        controller.should_not be_signed_in
      end
    end
  end
end
