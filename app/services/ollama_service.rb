require 'net/http'
require 'json'

class OllamaService
  OLLAMA_HOST = ENV.fetch('OLLAMA_HOST', 'http://ollama:11434')
  
  def self.chat(message)
    new.chat(message)
  end

  def chat(message)
    uri = URI("#{OLLAMA_HOST}/api/chat")
    http = Net::HTTP.new(uri.host, uri.port)
    
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    
    request.body = {
      model: 'llama2',
      messages: [
        { role: 'user', content: message }
      ],
      stream: false
    }.to_json

    response = http.request(request)
    
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)['message']['content']
    else
      "Sorry, I couldn't process that request. Please try again later."
    end
  rescue StandardError => e
    Rails.logger.error("Ollama API Error: #{e.message}")
    "Sorry, there was an error processing your request."
  end
end