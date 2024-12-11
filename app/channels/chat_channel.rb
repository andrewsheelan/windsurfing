class ChatChannel < ApplicationCable::Channel
  def subscribed
    if params[:recipient_id].present?
      stream_from "chat_#{[ connection.current_user.id, params[:recipient_id] ].sort.join('_')}"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
