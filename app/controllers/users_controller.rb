class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :legal_user,   :only => :destroy
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    already_signed_in unless !signed_in?
    @user = User.new
    @title = "Register"
  end

  def create
    already_signed_in unless !signed_in?
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Register"
      @user.password = ""
      @user.password_confirmation = ""
      render :new
    end
  end

  def edit
    @title = "Edit User"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit User"
      render :edit
    end
  end

  def destroy
    target = User.find(params[:id])
    if current_user?(target)
      sign_out
      target.destroy
      flash[:success] = "Your account has been deleted."
      redirect_to root_path
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def legal_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless (current_user.admin? || current_user?(@user))
    end
end
