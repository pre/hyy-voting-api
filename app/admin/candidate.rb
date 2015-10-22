ActiveAdmin.register Candidate do

  # Allow all
  permit_params do
    Candidate.new.attributes.keys
  end

end
