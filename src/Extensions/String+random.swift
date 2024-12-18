import Foundation

/// Creates a new string containing random alphanumeric characters
/// - Parameter length: The desired length of the random string
/// - Returns: A string of the specified length containing random letters (a-z, A-Z) and numbers (0-9)
extension String {
	init(randomLength length: Int) {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		self = String((0..<length).map { _ in letters.randomElement()! })
	}
}
