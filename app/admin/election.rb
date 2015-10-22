ActiveAdmin.register Election do

  # Allow all
  permit_params do
    Election.new.attributes.keys
  end

end
