# Architecture Overview

The OpenAI Realtime SDK provides a type-safe Swift interface for real-time conversations with OpenAI models, supporting both text and audio modalities. The architecture is designed around event-driven communication and strong type safety.

## Components

### RealtimeAPI
Handles WebSocket communication with the OpenAI server:
- Manages WebSocket connection lifecycle
- Serializes and sends client events
- Deserializes server events
- Provides connection status updates

### Conversation
Manages conversation state and provides high-level APIs:
- Tracks conversation history and items
- Handles message sending and receiving
- Manages audio input/output
- Coordinates function calls and responses

### EventHandler
Provides type-safe event handling:
- Processes incoming server events
- Routes events to appropriate handlers
- Maintains type safety through Swift's type system
- Handles error conditions and retries

### Models
Domain-specific data models organized by feature:
- Audio: Audio data and transcription configuration
  - `Audio`: Raw audio data and transcripts
  - `InputAudioTranscription`: Speech-to-text settings
  - `AudioFormat`: Supported audio formats

- Conversation: Message and function call types
  - `Message`: Text and audio content
  - `Item`: Container for messages and function calls
  - `FunctionCall`: Function invocation data

- Session: Configuration and tools
  - `Session`: Conversation settings
  - `Tool`: Function definitions
  - `ToolChoice`: Function selection behavior

- Events: Communication protocol
  - `ClientEvent`: Events sent to server
  - `ServerEvent`: Events received from server
  - `Error`: Error handling types

## Event Flow

1. Client Sends Event
   ```swift
   // Client initiates action
   try await conversation.send(from: .user, text: "Hello")
   // Internally converts to ClientEvent and sends via WebSocket
   ```

2. Server Responds
   ```swift
   // Server processes request and sends ServerEvent
   // Events can be messages, function calls, or errors
   case .message(let message)
   case .functionCall(let call)
   case .error(let error)
   ```

3. EventHandler Processes
   ```swift
   // EventHandler receives raw event
   // Deserializes and routes to appropriate handler
   func handle(_ event: ServerEvent) async throws {
       switch event {
       case .response(let response):
           await processResponse(response)
       // Handle other event types
       }
   }
   ```

4. Conversation Updates
   ```swift
   // Conversation state is updated
   // Clients are notified of changes
   conversation.items.append(newItem)
   await delegate?.conversation(self, didReceive: response)
   ```

## Error Handling

The SDK provides comprehensive error handling:
- Connection issues via `OpenAIRealtimeError.connection`
- Server errors via `ServerError`
- Invalid events via `OpenAIRealtimeError.invalidEventType`
- Function call errors via error events

## Usage Example

```swift
// Create a conversation
let conversation = try await OpenAI.createConversation(
    model: "gpt-4",
    instructions: "You are a helpful assistant."
)

// Send a message
try await conversation.send(from: .user, text: "Hello!")

// Handle responses
conversation.delegate = MyConversationDelegate()

// Define function
let weatherTool = Tool(
    type: "function",
    name: "get_weather",
    description: "Get weather for location",
    parameters: // ... parameter definition
)

// Update session with tool
try await conversation.updateSession { session in
    session.tools = [weatherTool]
}
```

## Best Practices

1. Error Handling
   - Always handle connection errors
   - Provide fallbacks for function calls
   - Log and report server errors

2. Resource Management
   - Close conversations when done
   - Monitor token usage
   - Handle audio resources properly

3. Type Safety
   - Use strongly-typed models
   - Handle all event cases
   - Validate function parameters

4. Testing
   - Mock WebSocket connections
   - Test error conditions
   - Verify event handling
