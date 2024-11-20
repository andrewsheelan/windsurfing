import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity"]

  connect() {
    console.log("Cart controller connected")
  }

  incrementQuantity(event) {
    event.preventDefault()
    const input = this.quantityTarget
    const currentValue = parseInt(input.value)
    const maxValue = parseInt(input.max)
    
    if (currentValue < maxValue) {
      input.value = currentValue + 1
      input.classList.add('scale-110')
      setTimeout(() => input.classList.remove('scale-110'), 200)
    }
  }

  decrementQuantity(event) {
    event.preventDefault()
    const input = this.quantityTarget
    const currentValue = parseInt(input.value)
    
    if (currentValue > 1) {
      input.value = currentValue - 1
      input.classList.add('scale-90')
      setTimeout(() => input.classList.remove('scale-90'), 200)
    }
  }

  addToCartSuccess(event) {
    const [data, _status, _xhr] = event.detail
    
    // Show animated success notification
    const notification = document.createElement('div')
    notification.className = 'fixed top-4 right-4 bg-green-50 p-4 rounded-md shadow-lg transform transition-all duration-500 ease-out translate-x-full opacity-0'
    notification.innerHTML = `
      <div class="flex items-center">
        <svg class="h-5 w-5 text-green-400 animate-bounce" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
        </svg>
        <p class="ml-3 text-sm font-medium text-green-800">
          Product added to cart successfully!
        </p>
      </div>
    `
    
    document.body.appendChild(notification)
    
    // Animate notification in
    requestAnimationFrame(() => {
      notification.classList.remove('translate-x-full', 'opacity-0')
    })
    
    // Animate notification out
    setTimeout(() => {
      notification.classList.add('translate-x-full', 'opacity-0')
      setTimeout(() => notification.remove(), 500)
    }, 3000)
  }
}