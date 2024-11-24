require 'net/http'
require 'json'

class OllamaService
  def self.chat(message)
    uri = URI("#{ENV.fetch('OLLAMA_HOST', 'http://ollama:11434')}/api/generate")
    
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = {
      model: "phi",
      prompt: message,
      stream: false
    }.to_json
    response = Net::HTTP.start(
      uri.hostname, uri.port, read_timeout: 120, open_timeout: 10
      ) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)["response"]
    else
      "I apologize, but I'm having trouble processing your request at the moment. Please try again later."
    end
  rescue StandardError => e
    Rails.logger.error "Ollama API Error: #{e.message}"
    "I apologize, but I'm experiencing technical difficulties. Please try again later."
  end
end