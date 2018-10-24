class RemoveCommentFromVote < ActiveRecord::Migration[5.0]
  def change
    remove_column :votes, :comment
  end
end
