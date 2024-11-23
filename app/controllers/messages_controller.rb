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
      if @message.save
        # If the recipient is the AI user, get response from Ollama
        if @message.recipient.email == 'john@example.com'
          ai_response = OllamaService.chat(@message.content)
          Message.create!(
            content: ai_response,
            user: User.find_by(email: 'john@example.com'),
            recipient: current_user
          )
        end
        
        format.html { redirect_to messages_path(recipient_id: @message.recipient_id) }
        format.json { head :ok }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :recipient_id)
  end
end