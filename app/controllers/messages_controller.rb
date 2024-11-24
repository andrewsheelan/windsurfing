class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message.where(
      "(user_id = ? AND recipient_id = ?) OR (user_id = ? AND recipient_id = ?)",
      current_user.id, params[:recipient_id],
      params[:recipient_id], current_user.id
    ).order(created_at: :asc)
    
    @recipient = User.find(params[:recipient_id]) if params[:recipient_id]
    @message = Message.new
  end

  def create
    @message = current_user.messages.build(message_params)

    respond_to do |format|
        ai_response = OllamaService.chat(@message.content)
      if @message.update(ai_response: ai_response)
        format.turbo_stream { 
            render turbo_stream: turbo_stream.append(
              "chat_#{current_user.id}",
              partial: "messages/message",
              locals: { message: @message }
            )
          }
        format.html { redirect_to messages_path(user_id: @message.user_id) }
        format.json { head :ok }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end