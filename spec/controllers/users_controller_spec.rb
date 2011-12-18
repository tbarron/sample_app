require 'spec_helper'

describe UsersController do
  render_views

  # ---------------------------------------------------------------------
  describe "GET :show" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  # ---------------------------------------------------------------------
  describe "GET :new" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Register")
    end

    it "should have a name field" do
      get :new
      hsa = "input[name='user[name]'][type='text']"
      response.should have_selector(hsa)
    end

    it "should have an email field" do
      get :new
      hsa = "input[name='user[email]'][type='text']"
      response.should have_selector(hsa)
    end

    it "should have a password field" do
      get :new
      hsa = "input[name='user[password]'][type='password']"
      response.should have_selector(hsa)
    end

    it "should have a password confirmation field" do
      get :new
      hsa = "input[name='user[password_confirmation]'][type='password']"
      response.should have_selector(hsa)
    end
  end

  # ---------------------------------------------------------------------
  describe "POST :create" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "",
                  :email => "",
                  :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Register")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

      it "should clear the password field" do
        post :create, :user => @attr.merge(:password => "foobar")
        response.should have_selector("input", 
                                      :name => "user[password]",
                                      :value => "")
        
      end

      it "should clear the password confirmation field" do
        post :create, :user => @attr.merge(:password_confirmation => "foobar")
        response.should have_selector("input", 
                                      :name => "user[password_confirmation]",
                                      :value => "")
        
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => "New User",
                  :email => "user@example.com",
                  :password => "SpicyRice",
                  :password_confirmation => "SpicyRice" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
    end
  end
end
