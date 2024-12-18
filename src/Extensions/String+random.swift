import Foundation

/// Provides random string generation functionality
extension String {
	init(randomLength length: Int) {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		self = String((0..<length).map { _ in letters.randomElement()! })
	}
}
