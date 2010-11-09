class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :furrows do |t|
      t.integer :user_id,       :required => true
      t.string  :action,        :required => true, :default => 'unfollow'
      t.string  :state,         :required => true, :default => 'unstarted'
      t.integer :seed_user_id,  :required => true
      t.integer :duration,      :required => true

      t.timestamps
    end

    create_table :users do |t|
      t.string :twitter_id,     :required => true
      t.string :name
      t.string :nickname,       :required => true
      t.string :image_url
      t.string :token
      t.string :secret

      t.timestamps
    end
  end

  def self.down
    drop_table :furrows
    drop_table :users
  end
end
