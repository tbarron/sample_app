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
    @attr = { :name => "Example User", :email => "user@example.com" }
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
end
