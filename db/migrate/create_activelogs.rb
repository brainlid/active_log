class CreateActiveLogs < ActiveRecord::Migration
  def self.up
    # Create the table for logging model changes.
    create_table :active_logs do |t|
      # Track the ID of the modifying user. Allow for nulls because changes can happen outside a web session
      # in rake tasks, IRB, etc.
      t.integer :user_id, :null => true
      t.string :type
      t.integer :ar_id
      t.string :ar_type
      t.boolean :was_created, :default => false
      t.text :changed_content
      t.datetime :expiry
      t.timestamps
    end

    # Add indexes for better finds
    add_index :active_logs, :type
    add_index :active_logs, :ar_id
    add_index :active_logs, :ar_type

    # Uses foreigner plugin/gem to add foreign keys.
    # Think about the behavior you want. Use ":dependent => :delete" if deleting a user should
    # remove the change logs for the user. Use ":dependent => :nullify" if the audit log entries should be kept but the
    # link to the creating user is lost. Don't specify a cascading operation to prevent the deletion of a user. This
    # would require a user to be flagged as "inactive" and be treated as deleted. This is the safest for integrity as
    # the audit log of changes remains even after the user is gone.
    #
    #add_foreign_key :active_logs, :users
  end

  def self.down
    drop_table :active_logs
  end
end
