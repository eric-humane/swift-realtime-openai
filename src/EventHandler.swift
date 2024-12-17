import Foundation
import Models

/// A type-safe event handler for managing ServerEvent callbacks
public final class EventHandler {
    /// Type definition for event callbacks
    public typealias EventCallback<T> = (T) -> Void

    /// Storage for event handlers, keyed by event type name
    private var handlers: [String: Any] = [:]

    public init() {}

    /// Register a callback for a specific ServerEvent type
    /// - Parameter callback: The callback to be executed when an event of type T is received
    public func on<T: ServerEvent>(_ callback: @escaping EventCallback<T>) {
        handlers[String(describing: T.self)] = callback
    }

    /// Handle an incoming ServerEvent in a type-safe manner
    /// - Parameter event: The ServerEvent to handle
    public func handle(_ event: ServerEvent) {
        let eventType = String(describing: type(of: event))
        guard let handler = handlers[eventType] else { return }

        switch event {
        case let textEvent as ServerEvent.Text:
            (handler as? EventCallback<ServerEvent.Text>)?(textEvent)
        case let audioEvent as ServerEvent.Audio:
            (handler as? EventCallback<ServerEvent.Audio>)?(audioEvent)
        case let errorEvent as ServerEvent.Error:
            (handler as? EventCallback<ServerEvent.Error>)?(errorEvent)
        case let functionCallEvent as ServerEvent.FunctionCall:
            (handler as? EventCallback<ServerEvent.FunctionCall>)?(functionCallEvent)
        case let messageStartEvent as ServerEvent.MessageStart:
            (handler as? EventCallback<ServerEvent.MessageStart>)?(messageStartEvent)
        case let messageEndEvent as ServerEvent.MessageEnd:
            (handler as? EventCallback<ServerEvent.MessageEnd>)?(messageEndEvent)
        default:
            break
        }
    }
}

// MARK: - Convenience Methods

extension EventHandler {
    /// Register a callback for text events
    /// - Parameter callback: The callback to be executed when a text event is received
    public func onText(_ callback: @escaping EventCallback<ServerEvent.Text>) {
        on(callback)
    }

    /// Register a callback for audio events
    /// - Parameter callback: The callback to be executed when an audio event is received
    public func onAudio(_ callback: @escaping EventCallback<ServerEvent.Audio>) {
        on(callback)
    }

    /// Register a callback for error events
    /// - Parameter callback: The callback to be executed when an error event is received
    public func onError(_ callback: @escaping EventCallback<ServerEvent.Error>) {
        on(callback)
    }

    /// Register a callback for function call events
    /// - Parameter callback: The callback to be executed when a function call event is received
    public func onFunctionCall(_ callback: @escaping EventCallback<ServerEvent.FunctionCall>) {
        on(callback)
    }

    /// Register a callback for message start events
    /// - Parameter callback: The callback to be executed when a message start event is received
    public func onMessageStart(_ callback: @escaping EventCallback<ServerEvent.MessageStart>) {
        on(callback)
    }

    /// Register a callback for message end events
    /// - Parameter callback: The callback to be executed when a message end event is received
    public func onMessageEnd(_ callback: @escaping EventCallback<ServerEvent.MessageEnd>) {
        on(callback)
    }
}
