ActiveAdmin.register Voter do

  # Allow all
  permit_params do
    Voter.new.attributes.keys
  end

end
