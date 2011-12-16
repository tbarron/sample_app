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
  end
end
