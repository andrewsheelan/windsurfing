class AddAiResponseToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :ai_response, :text
  end
end
