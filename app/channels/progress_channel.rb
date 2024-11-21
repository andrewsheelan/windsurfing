class ProgressChannel < ApplicationCable::Channel
  def subscribed
    stream_from "progress_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
