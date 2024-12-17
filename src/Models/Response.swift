import Foundation

public struct Response: Identifiable, Codable, Equatable, Sendable {
	public struct Config: Codable, Equatable, Sendable {
		public let modalities: [Session.Modality]
		public let instructions: String
		public let voice: Session.Voice
		public let outputAudioFormat: Session.AudioFormat
		public let tools: [Session.Tool]
		public let toolChoice: Session.ToolChoice
		public let temperature: Double
		public let maxOutputTokens: Int?
	}

	public enum Status: String, Codable, Equatable, Sendable {
		case failed
		case completed
		case cancelled
		case incomplete
		case inProgress = "in_progress"
	}

	public struct Usage: Codable, Equatable, Sendable {
		public let totalTokens: Int
		public let inputTokens: Int
		public let outputTokens: Int
	}

	public let id: String
	public let status: Status
	public let output: [Item]
	public let usage: Usage?
}
