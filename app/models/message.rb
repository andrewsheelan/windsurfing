class Message < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  validates :user_id, presence: true

  after_create_commit -> { broadcast_append_to "chat_#{user_id}",
                          target: "chat_#{user_id}",
                          partial: "messages/message",
                          locals: { message: self } }
end
