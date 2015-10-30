ActiveAdmin.register Candidate do

  # Allow all
  permit_params do
    Candidate.new.attributes.keys
  end

  action_item :index do
    link_to 'Jaa ehdokasnumerot',
            give_numbers_admin_candidates_path,
            :confirm => 'Jaetaanko ehdokasnumerot?'
  end

  collection_action :give_numbers do
    if Candidate.give_numbers!
      redirect_to admin_candidates_path, :notice => 'Ehdokkaat on numeroitu!'
    else
      redirect_to admin_candidates_path, :alert => 'Numerointi epäonnistui tuntemattomasta syystä.'
    end
  end
end
