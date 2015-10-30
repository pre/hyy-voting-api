ActiveAdmin.register Alliance do

  # Allow all
  permit_params do
    Alliance.new.attributes.keys
  end

end
