class User < ActiveRecord::Base
  attr_accessible :username,:email, :password, :password_confirmation, :status,:dashboard
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_length_of :password ,:minimum => 5 , :on => :create
  validates_presence_of :password, :on => :create
  validates_presence_of :email , :username
  validates_uniqueness_of :email, :username

  validates :status, :inclusion => { :in => ['R', 'A', 'M'] }
  
  has_many :anuncios

  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end



  def self.search(username)
     if username
      where('username LIKE ?',"%#{username}%")
    else
      scoped
    end
  end

end
