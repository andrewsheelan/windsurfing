import consumer from "./consumer"

consumer.subscriptions.create("ProgressChannel", {
  connected() {
    // Called when the subscription is ready for use
  },

  disconnected() {
    // Called when the subscription has been terminated
  },

  received(data) {
    // Called when there's incoming data on the websocket
    const progressBar = document.querySelector(`[data-task-id="${data.task_id}"]`)
    if (progressBar) {
      progressBar.style.width = `${data.progress}%`
      progressBar.setAttribute('aria-valuenow', data.progress)
      
      if (data.status === "completed") {
        progressBar.classList.add('bg-success')
      }
    }
  }
})