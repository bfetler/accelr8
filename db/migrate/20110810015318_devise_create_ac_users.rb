class DeviseCreateAcUsers < ActiveRecord::Migration
  def self.up
    create_table(:accelerator_users) do |t|
      t.database_authenticatable :null => false
#     t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      t.string :name

      t.timestamps
    end

    add_index :accelerator_users, :name,                 :unique => true
    add_index :accelerator_users, :email,                :unique => true
#   add_index :accelerator_users, :reset_password_token, :unique => true
    # add_index :accelerator_users, :confirmation_token,   :unique => true
    # add_index :accelerator_users, :unlock_token,         :unique => true
    # add_index :accelerator_users, :authentication_token, :unique => true

    add_column :accelerators, :owner, :string
    add_column :accelerators, :izzaproved, :string
  end

  def self.down
    remove_column :accelerators, :izzaproved
    remove_column :accelerators, :owner
    drop_table :accelerator_users
  end
end
