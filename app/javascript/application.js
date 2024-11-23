// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Mobile menu toggle
window.toggleMobileMenu = function() {
  const mobileMenu = document.getElementById('mobile-menu');
  if (mobileMenu.classList.contains('hidden')) {
    mobileMenu.classList.remove('hidden');
  } else {
    mobileMenu.classList.add('hidden');
  }
}

// Chat functionality
document.addEventListener('alpine:init', () => {
  Alpine.data('chat', () => ({
    open: false,
    messages: [
      {
        type: 'assistant',
        content: 'Hello! I\'m your Windsurfing Assistant. How can I help you today?'
      }
    ],
    
    async sendMessage() {
      const input = this.$refs.chatInput;
      const message = input.value.trim();
      
      if (!message) return;
      
      // Add user message
      this.messages.push({
        type: 'user',
        content: message
      });
      
      input.value = '';
      
      try {
        // Add loading message
        this.messages.push({
          type: 'assistant',
          content: 'Thinking...'
        });
        
        // Make API call to your backend
        const response = await fetch('/api/chat', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ message })
        });
        
        if (!response.ok) throw new Error('Failed to get response');
        
        const data = await response.json();
        
        // Replace loading message with actual response
        this.messages[this.messages.length - 1] = {
          type: 'assistant',
          content: data.response
        };
      } catch (error) {
        console.error('Error:', error);
        // Replace loading message with error
        this.messages[this.messages.length - 1] = {
          type: 'assistant',
          content: 'Sorry, I encountered an error. Please try again.'
        };
      }
      
      // Scroll to bottom
      this.$nextTick(() => {
        const container = document.getElementById('chat-messages');
        container.scrollTop = container.scrollHeight;
      });
    }
  }));
});
