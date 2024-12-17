import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Models

public final class RealtimeAPI: NSObject, Sendable {
    @MainActor public var onDisconnect: (@Sendable () -> Void)?
    public let events: AsyncThrowingStream&lt;ServerEvent, Error&gt;
    public let eventHandler: EventHandler

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let task: URLSessionWebSocketTask
    private let stream: AsyncThrowingStream&lt;ServerEvent, Error&gt;.Continuation

    public init(connectingTo request: URLRequest) {
        (events, stream) = AsyncThrowingStream.makeStream(of: ServerEvent.self)
        task = URLSession.shared.webSocketTask(with: request)
        eventHandler = EventHandler()

        super.init()

        task.delegate = self
        receiveMessage()
        task.resume()
    }

    public convenience init(authToken: String, model: String = "gpt-4o-realtime-preview-2024-10-01") {
        var request = URLRequest(url: URL(string: "wss://api.openai.com/v1/realtime")!.appending(queryItems: [
            URLQueryItem(name: "model", value: model),
        ]))
        request.addValue("realtime=v1", forHTTPHeaderField: "OpenAI-Beta")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        self.init(connectingTo: request)
    }

    deinit {
        task.cancel(with: .goingAway, reason: nil)
        stream.finish()
        onDisconnect?()
    }

    private func receiveMessage() {
        task.receive { [weak self] result in
            guard let self else { return }

            switch result {
                case let .failure(error):
                    self.stream.yield(error: error)
                case let .success(message):
                    switch message {
                        case let .string(text):
                            if let data = text.data(using: .utf8),
                               let event = try? self.decoder.decode(ServerEvent.self, from: data) {
                                self.stream.yield(event)
                                self.eventHandler.handle(event)
                            } else {
                                self.stream.yield(error: RealtimeAPIError.invalidMessage)
                            }

                        case .data:
                            self.stream.yield(error: RealtimeAPIError.invalidMessage)

                        @unknown default:
                            self.stream.yield(error: RealtimeAPIError.invalidMessage)
                    }
            }

            self.receiveMessage()
        }
    }

    public func send(event: ClientEvent) async throws {
        let message = try URLSessionWebSocketTask.Message.string(String(data: encoder.encode(event), encoding: .utf8)!)
        try await task.send(message)
    }
}

// MARK: - Event Handling Convenience Methods

extension RealtimeAPI {
    public func onText(_ callback: @escaping EventHandler.EventCallback&lt;ServerEvent.Text&gt;) {
        eventHandler.onText(callback)
    }

    public func onAudio(_ callback: @escaping EventHandler.EventCallback&lt;ServerEvent.Audio&gt;) {
        eventHandler.onAudio(callback)
    }

    public func onError(_ callback: @escaping EventHandler.EventCallback&lt;ServerEvent.Error&gt;) {
        eventHandler.onError(callback)
    }

    public func onFunctionCall(_ callback: @escaping EventHandler.EventCallback&lt;ServerEvent.FunctionCall&gt;) {
        eventHandler.onFunctionCall(callback)
    }

    public func onMessageStart(_ callback: @escaping EventHandler.EventCallback&lt;ServerEvent.MessageStart&gt;) {
        eventHandler.onMessageStart(callback)
    }

    public func onMessageEnd(_ callback: @escaping EventHandler.EventCallback&lt;ServerEvent.MessageEnd&gt;) {
        eventHandler.onMessageEnd(callback)
    }
}

// MARK: - URLSession WebSocket Delegate

extension RealtimeAPI: URLSessionWebSocketDelegate {
    public func urlSession(_: URLSession, webSocketTask _: URLSessionWebSocketTask, didCloseWith _: URLSessionWebSocketTask.CloseCode, reason _: Data?) {
        stream.finish()
        Task { @MainActor in
            onDisconnect?()
        }
    }
}

enum RealtimeAPIError: OpenAIRealtimeError {
    case invalidMessage
}
