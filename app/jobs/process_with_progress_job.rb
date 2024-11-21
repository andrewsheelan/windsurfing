class ProcessWithProgressJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    total_steps = 10

    total_steps.times do |step|
      # Simulate some work
      sleep(1)

      # Calculate progress percentage
      progress = ((step + 1).to_f / total_steps * 100).round

      # Broadcast progress
      ActionCable.server.broadcast "progress_channel", {
        task_id: task_id,
        progress: progress,
        status: progress == 100 ? "completed" : "processing"
      }
    end
  end
end
