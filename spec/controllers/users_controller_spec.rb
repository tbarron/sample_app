require 'spec_helper'

describe UsersController do
  render_views

  # ---------------------------------------------------------------------
  describe "GET :index" do
    describe "for unauthenticated users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for authenticated users" do
      before (:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "bob@example.com")
        third = Factory(:user, :name => "Ben", :email => "ben@example.com")

        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :name => Factory.next(:name),
                                   :email => Factory.next(:email))
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All Users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end

      describe "for admin users" do
        before(:each) do
          @admin = Factory(:user, :email => "admin@example.com",
                                  :name =>  "SuperUser",
                                  :admin => true)
          test_sign_in(@admin)
        end

        it "should show a delete link for each user" do
          get :index
          @users[0..5].each do |user|
            response.should have_selector("a", 
                                          :href => '/users/' + user.id.to_s, 
                                          :content => "delete")
          end
        end

        it "should not show a delete link for the admin" do
          get :index, :page => 2
          response.should have_selector("li", :content => @admin.name)
          response.should_not have_selector("a", 
                                            :content => "delete",
                                            :href => '/users/' + 
                                                     @admin.id.to_s)
        end
      end

      describe "for unprivileged users" do
        before(:each) do
          user = Factory(:user, :email => "admin@example.com")
          test_sign_in(user)
        end

        it "should not show a delete link for each user" do
          get :index
          @users[0..5].each do |user|
            response.should_not have_selector("a", 
                                              :content => "delete")
          end
        end
      end
    end
  end

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

    describe "for authenticated users" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should redirect to root url with a flashed message" do
        get :new
        response.should redirect_to(root_path)
        flash[:info].should =~ /already signed in. Please sign out before/
      end
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

    describe "for authenticated users" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should redirect to root url" do
        get :new
        response.should redirect_to(root_path)
        flash[:info].should =~ /already signed in. Please sign out before/
      end
    end
  end

  describe "GET :edit" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @gravatar_url = "http://gravatar.com/emails"
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit User")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      response.should have_selector("a", :href => @gravatar_url,
                                         :content => "change")
    end

    it "should open the Gravatar page in a new window or tab" do
      get :edit, :id => @user
      response.should have_selector("a", :href => @gravatar_url,
                                         :target => "_blank")
    end

    it "should have a 'delete this account' link" do
      get :edit, :id => @user
      response.should have_selector("a", 
                                    :content => "Delete this account")
    end
  end

  describe "PUT :update" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      before(:each) do
        @attr = { :email => "", 
                  :name => "", 
                  :password => "",
                  :password_confirmation => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit User")
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => "New Name", 
                  :email => "user@example.org",
                  :password => "barbaz", 
                  :password_confirmation => "barbaz" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update pages" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do
      it "should deny access to :edit" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to :update" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "nonesuch@nowhere.com")
        test_sign_in(wrong_user)
      end

      it "should require matching users for :edit" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for :update" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE :destroy" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "as an unauthenticated user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should not delete a record" do
        lambda do
          delete :destroy, :id => @user
        end.should_not change(User, :count)
      end
    end

    describe "as an unprivileged user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end

      it "should allow user to delete self" do   # mine
        lambda do
          test_sign_in(@user)
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should not allow user to delete someone else" do   # mine
        lambda do
          test_sign_in(@user)
          other = Factory(:user, :email => "yetanother@example.com")
          delete :destroy, :id => other
        end.should change(User, :count).by(1)
      end
    end

    describe "as an admin user" do
      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", 
                               :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
end
