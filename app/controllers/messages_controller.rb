class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    binding.pry
    @recipient = User.find(params[:recipient_id])
    @messages = Message.where(
      "(user_id = ? AND recipient_id = ?) OR (user_id = ? AND recipient_id = ?)",
      current_user.id, @recipient.id,
      @recipient.id, current_user.id
    ).order(created_at: :asc)

    respond_to do |format|
      format.html { render partial: "messages/message", collection: @messages }
      format.json { render json: @messages }
    end
  end

  def create
    binding.pry

    @message = current_user.messages.build(message_params)

    if @message.save!
      ActionCable.server.broadcast(
        "chat_#{[ @message.user_id, @message.recipient_id ].sort.join('_')}",
        message_html: render_to_string(partial: "messages/message", locals: { message: @message })
      )
      head :ok
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :recipient_id)
  end
end
