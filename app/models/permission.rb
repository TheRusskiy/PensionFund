class Permission
  # BIG THANKS TO RYAN BATES
  def self.actions
    [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  def self.resources
    [:companies, :contracts, :employees, :job_positions,
     :payments, :property_types, :transfers, :users]
  end

  def initialize user
    @allowed = {}
    @forbidden_params = {}
    @user = user

    allow [:home],[:index]
    allow [:application],[:authenticate, :logout]

    if @user.nil?
      guest_permit
      return
    end
    case @user.role_id
      when 0 then admin_permit
      when 1 then operator_permit
      when 2 then inspector_permit
      when 3 then manager_permit
      else raise Exception.new 'Unknown user role!'
    end
  end

  def permit? resource, action, obj = nil
    allowed = @allowed[[resource.to_s, action.to_s]]
    return false unless allowed
    allowed == true || obj && allowed.call(obj)
  end

  def permit_parameters? resource, parameter
    true unless @forbidden_params[[resource.to_s, parameter.to_s]]
  end

  def guest_permit
    allow([:companies, :employees], [:index, :show])
    forbid_parameters(:user, :role_id)
  end

  def admin_permit
    allow(Permission.resources, Permission.actions)
  end

  def operator_permit
    allow(Permission.resources - [:users], Permission.actions)
    allow([:users], [:index, :show])
    allow_to_change_own_user
    forbid_parameters(:user, :role_id)
  end

  def inspector_permit
    disallowed = [:new, :create, :edit, :update, :destroy]
    allowed = Permission.actions-disallowed
    res = Permission.resources - [:users]
    allow(res, allowed)
    allow_to_change_own_user
    forbid_parameters(:user, :role_id)
  end

  def manager_permit
    inspector_permit
  end

  def allow resources, actions, &block
    Array(resources).each do |r|
      Array(actions).each do |a|
        #noinspection RubySimplifyBooleanInspection
        @allowed[[r.to_s,a.to_s]]= block || true
      end
    end
  end

  def forbid_parameters  resources, parameters
    Array(resources).each do |r|
      Array(parameters).each do |a|
        @forbidden_params[[r.to_s,a.to_s]]= true
      end
    end
  end

  def allow_to_change_own_user
    allow([:users], Permission.actions - [:edit, :update, :destroy, :create, :new])
    allow([:users], [:edit, :update]) do |obj|
      @user == obj
    end
  end

  def to_s
    @user.nil? ? "Permission for guest" : "Permission for #{@user.email} (#{@user.role})"
  end

end