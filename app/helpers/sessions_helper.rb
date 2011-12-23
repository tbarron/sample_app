module SessionsHelper

  @@persistence = false

  # ----------------------------------------------------------------------
  def persistence?
    @@persistence
  end

  # ----------------------------------------------------------------------
  def sign_in(user)
    if @@persistence
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]
      File.open("/tmp/cookies.txt", 'w') {|f| f.write(cookies.to_s)}
    else
      session[:current_user_id] = user.id
      File.open("/tmp/cookies.txt", 'w') {|f| f.write(cookies.to_s)}
    end
    self.current_user = user
  end

  # ----------------------------------------------------------------------
  def current_user=(user)
    @current_user = user
  end

  # ----------------------------------------------------------------------
  def current_user
    if @@persistence
      @current_user ||= user_from_remember_token
    else
      @current_user ||= session[:current_user_id] \
                        && User.find_by_id(session[:current_user_id])
    end
  end

  # ----------------------------------------------------------------------
  def current_user?(user)
    user == current_user
  end

  # ----------------------------------------------------------------------
  def deny_access
    remember_target
    redirect_to(signin_path, 
                :notice => "Please sign in to access this page")
  end

  # ----------------------------------------------------------------------
  def redirect_back_or(default)
    redirect_to(session[:target] || default)
    forget_target
  end  

  # ----------------------------------------------------------------------
  def signed_in?
    !current_user.nil?
  end

  # ----------------------------------------------------------------------
  def already_signed_in
    flash[:info] = "You're already signed in. Please sign out before " +
                   "trying to create a new account."
    redirect_to(root_path)
  end

  # ----------------------------------------------------------------------
  def sign_out
    if @@persistence
      cookies.delete(:remember_token)
    else
      session[:current_user_id] = nil
    end
    self.current_user = nil
  end

  # ----------------------------------------------------------------------
  private

    # --------------------------------------------------------------------
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    # --------------------------------------------------------------------
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    # --------------------------------------------------------------------
    def remember_target
      session[:target] = request.fullpath
    end

    # --------------------------------------------------------------------
    def forget_target
      session[:target] = nil
    end
end
