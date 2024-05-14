class AddStatusToEventType < ActiveRecord::Migration[7.1]
  def change
    add_column :event_types, :status, :integer, default: 1
  end
end
