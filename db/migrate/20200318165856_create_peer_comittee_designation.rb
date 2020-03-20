class CreatePeerComitteeDesignation < ActiveRecord::Migration[5.0]
  def change
    create_table :peer_comittee_designations do |t|
      t.references :student, foreign_key: false
      t.integer :peer1
      t.integer :peer2
      t.timestamps
    end
  end
end