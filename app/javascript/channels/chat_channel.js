import consumer from "./consumer"

let currentSubscription = null;

document.addEventListener('turbo:load', () => {
  setupChat();
});

// Also handle Turbo cache restore events
document.addEventListener('turbo:render', () => {
  setupChat();
});

function setupChat() {
  const chatWindow = document.getElementById('chat-window');
  if (!chatWindow) return;

  const userId = chatWindow.dataset.userId;
  let recipientId = chatWindow.dataset.recipientId;

  function setupChatSubscription(recipientId) {
    if (currentSubscription) {
      currentSubscription.unsubscribe();
    }

    if (!recipientId) return;

    const roomId = [userId, recipientId].sort().join('_');
    
    currentSubscription = consumer.subscriptions.create(
      { channel: "ChatChannel", room: roomId },
      {
        connected() {
          console.log("Connected to chat channel", roomId);
        },

        disconnected() {
          console.log("Disconnected from chat channel");
        },

        received(data) {
          console.log("Received message:", data);
          const messagesContainer = document.getElementById('messages');
          if (messagesContainer) {
            messagesContainer.insertAdjacentHTML('beforeend', data.message_html);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
          }
        }
      }
    );
  }

  // Set up initial subscription
  if (recipientId) {
    setupChatSubscription(recipientId);
  }

  // Handle recipient changes
  const recipientSelect = document.getElementById('chat-recipient');
  if (recipientSelect) {
    recipientSelect.addEventListener('change', (e) => {
      recipientId = e.target.value;
      chatWindow.dataset.recipientId = recipientId;
      
      // Clear existing messages
      const messagesContainer = document.getElementById('messages');
      messagesContainer.innerHTML = '';
      
      // Fetch messages for new recipient
      fetch(`/messages?recipient_id=${recipientId}`)
        .then(response => response.text())
        .then(html => {
          messagesContainer.innerHTML = html;
          messagesContainer.scrollTop = messagesContainer.scrollHeight;
        })
        .catch(error => console.error('Error fetching messages:', error));

      // Setup new subscription
      setupChatSubscription(recipientId);

      // Enable/disable chat input
      const chatInput = document.getElementById('chat-input');
      const chatSubmit = document.querySelector('#chat-form button[type="submit"]');
      chatInput.disabled = !recipientId;
      chatSubmit.disabled = !recipientId;
    });
  }

  // Handle chat form submission
  const form = document.getElementById('chat-form');
  if (form) {
    // Remove any existing event listeners
    const newForm = form.cloneNode(true);
    form.parentNode.replaceChild(newForm, form);
    
    newForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      console.log("Form submitted");
      
      const input = document.getElementById('chat-input');
      const message = input.value.trim();
      
      if (message && recipientId) {
        try {
          console.log("Sending message:", message, "to recipient:", recipientId);
          const response = await fetch('/messages', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({
              message: {
                content: message,
                recipient_id: recipientId
              }
            })
          });

          if (response.ok) {
            input.value = '';
          } else {
            console.error('Failed to send message:', await response.text());
          }
        } catch (error) {
          console.error('Error sending message:', error);
        }
      }
    });
  }

  // Store chat window state
  let isChatMinimized = false;
  let chatWindowVisible = true;

  // Handle minimize/close buttons
  const minimizeBtn = document.querySelector('.minimize-chat');
  const closeBtn = document.querySelector('.close-chat');
  const messagesContainer = document.getElementById('messages');
  const chatForm = document.getElementById('chat-form');

  if (minimizeBtn && closeBtn && messagesContainer && chatForm) {
    // Remove existing event listeners
    const newMinimizeBtn = minimizeBtn.cloneNode(true);
    const newCloseBtn = closeBtn.cloneNode(true);
    minimizeBtn.parentNode.replaceChild(newMinimizeBtn, minimizeBtn);
    closeBtn.parentNode.replaceChild(newCloseBtn, closeBtn);

    // Add new event listeners
    newMinimizeBtn.addEventListener('click', () => {
      isChatMinimized = !isChatMinimized;
      messagesContainer.style.display = isChatMinimized ? 'none' : 'block';
      chatForm.parentElement.style.display = isChatMinimized ? 'none' : 'block';
      newMinimizeBtn.querySelector('span').textContent = isChatMinimized ? '□' : '_';
      
      // Adjust chat window height when minimized
      chatWindow.style.height = isChatMinimized ? 'auto' : '600px';
    });

    newCloseBtn.addEventListener('click', () => {
      chatWindowVisible = false;
      chatWindow.style.display = 'none';
    });
  }
}