class Token

  attr_accessor :token
  attr_accessor :user

  def initialize(token)
    self.token = token
    self.user = { id: 100, email: "moi@hei.com" } # TODO
  end

  def valid?
    validate
  end

  def validate
    return false if token.blank? or user.blank?

    true
  end

end
