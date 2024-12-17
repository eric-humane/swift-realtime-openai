import Foundation

/// Represents all possible errors that can occur in the OpenAI Realtime SDK.
/// This enum provides a standardized way to handle errors across the SDK.
public enum OpenAIRealtimeError: Error {
    /// Indicates a connection-related error occurred
    /// - Parameter underlying: The underlying error that caused the connection issue
    case connection(underlying: Error)

    /// Indicates an invalid message was received or attempted to be sent
    case invalidMessage

    /// Indicates an error was returned from the OpenAI server
    /// - Parameter ServerError: The error details returned by the server
    case serverError(ServerError)

    /// Indicates an unknown or invalid event type was encountered
    /// - Parameter String: The invalid event type that was encountered
    case invalidEventType(String)

    /// Indicates that audio transcription failed
    /// - Parameter String: The reason for the transcription failure
    case transcriptionFailed(String)
}
