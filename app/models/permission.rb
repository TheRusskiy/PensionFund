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
    @user = user
    case @user.role_id
      when 0 then guest_permit
      when 1 then admin_permit
      when 2 then operator_permit
      when 3 then inspector_permit
      when 4 then manager_permit
      else raise Exception.new 'Unknown user role!'
    end
  end

  def permit? resource, action, obj = nil
    allowed = @allowed[[resource, action]]
    return false unless allowed
    allowed == true || obj && allowed.call(obj)
  end

  def guest_permit
    allow([:companies, :employees], [:index, :show])
  end

  def admin_permit
    allow(Permission.resources, Permission.actions)
  end

  def operator_permit
    allow(Permission.resources - [:users], Permission.actions)
    allow([:users], Permission.actions - [:edit, :update, :destroy])
    allow([:users], [:edit, :update, :destroy]) do |obj|
      @user == obj
    end
  end

  def inspector_permit
    disallowed = [:new, :create, :edit, :update, :destroy]
    allowed = Permission.actions-disallowed
    res = Permission.resources - [:users]
    allow(res, allowed)
    allow_to_change_own_user
  end

  def manager_permit
    inspector_permit
  end

  def allow resource, actions, &block
    Array(resource).each do |r|
      Array(actions).each do |a|
        #noinspection RubySimplifyBooleanInspection
        @allowed[[r,a]]= block || true
      end
    end
  end

  def allow_to_change_own_user
    allow([:users], Permission.actions - [:edit, :update, :destroy])
    allow([:users], [:edit, :update, :destroy]) do |obj|
      @user == obj
    end
  end

  def to_s
    "Permission for #{@user.email} (#{@user.role})"
  end

end