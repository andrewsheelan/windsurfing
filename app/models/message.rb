class Message < ApplicationRecord
  belongs_to :user
  belongs_to :recipient, class_name: "User"

  validates :content, presence: true
  broadcasts_to ->(message) { "chat_#{[ message.user_id, message.recipient_id ].sort.join('_')}" }
end
