class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:room]}"
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    Message.create!(
      content: data["message"],
      user_id: current_user.id,
      recipient_id: data["recipient_id"]
    )
  end
end
