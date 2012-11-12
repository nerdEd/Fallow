class AddJobIdToFurrow < ActiveRecord::Migration
  def change
    add_column :furrows, :delayed_job_id, :integer
  end
end
