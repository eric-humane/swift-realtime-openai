import Foundation

public struct InputAudioTranscription: Codable, Equatable, Sendable {
    public var model: String

    public init(model: String = "whisper-1") {
        self.model = model
    }
}

public struct TurnDetection: Codable, Equatable, Sendable {
    public enum TurnDetectionType: String, Codable, Sendable {
        case serverVad = "server_vad"
        case none
    }

    public var type: TurnDetectionType
    public var threshold: Double
    public var prefixPaddingMs: Int
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
