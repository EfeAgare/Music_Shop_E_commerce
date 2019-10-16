class AddUserRefToInstruments < ActiveRecord::Migration[6.0]
  def change
    add_reference :instruments, :user, null: false, foreign_key: true
  end
end
