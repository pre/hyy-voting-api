class CreateCandidates < ActiveRecord::Migration[4.2]
  class LoadSchemaInsteadError < StandardError; end

  def change
    raise LoadSchemaInsteadError.new, "Use 'rake db:schema:load' to initialize the database schema."
  end
end
