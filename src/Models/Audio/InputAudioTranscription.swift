import Foundation

/// Configuration for transcribing input audio
public struct InputAudioTranscription: Codable, Equatable, Sendable {
    /// The model to use for transcription
    public var model: String

    public init(model: String = "whisper-1") {
        self.model = model
    }
}

/// Configuration for detecting turns in audio input
public struct TurnDetection: Codable, Equatable, Sendable {
    public enum TurnDetectionType: String, Codable, Sendable {
        case serverVad = "server_vad"
        case none
    }

    /// The type of turn detection.
    public var type: TurnDetectionType
    /// Activation threshold for VAD (0.0 to 1.0).
    public var threshold: Double
    /// Amount of audio to include before speech starts (in milliseconds).
    public var prefixPaddingMs: Int
    /// Duration of silence to detect speech stop (in milliseconds).
    public var silenceDurationMs: Int

    public init(
        type: TurnDetectionType,
        threshold: Double,
        prefixPaddingMs: Int,
        silenceDurationMs: Int
    ) {
        self.type = type
        self.threshold = threshold
        self.prefixPaddingMs = prefixPaddingMs
        self.silenceDurationMs = silenceDurationMs
    }
}
