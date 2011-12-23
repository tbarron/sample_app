# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name = User.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "should require an email address" do
    no_mail = User.new(@attr.merge(:email => ""))
    no_mail.should_not be_valid
  end

  it "should limit names to maximum length" do
    long_name = "a" * 51
    too_long = User.new(@attr.merge(:name => long_name))
    too_long.should_not be_valid
  end

  it "should accept valid email addresses" do
    addrl = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addrl.each do |addr|
      valid_user = User.new(@attr.merge(:email => addr))
      valid_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addrl = %w[user@foo,com user_at_foo.org example.user@foo.]
    addrl.each do |addr|
      invalid_user = User.new(@attr.merge(:email => addr))
      invalid_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_dup_email = User.new(@attr)
    user_dup_email.should_not be_valid
  end

  it "should reject duplicate email addresses ignoring case" do
    # "FOO@WHERE.COM" is a duplicate of "foo@where.com" 
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_dup_email = User.new(@attr)
    user_dup_email.should_not be_valid
  end

  describe "password_validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      User.new(:password_confirmation => short, 
               :password => short).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      User.new(:password_confirmation => long, 
               :password => long).should_not be_valid
    end
  end

  describe "password encryption" do
    before (:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong = User.authenticate(@attr[:email], "wrongpass")
        wrong.should == nil
      end

      it "should return nil for an email address with no user" do
        nosuch = User.authenticate("nonesuch@nowhere.com",
                                   @attr[:password])
        nosuch.should == nil
      end

      it "should return the user on email/password match" do
        good = User.authenticate(@attr[:email], @attr[:password])
        good.should == @user
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

    it "should be convertible to a non-admin" do
      @user.toggle!(:admin)
      @user.should be_admin
      @user.toggle!(:admin)
      @user.should_not be_admin
    end
  end
end
