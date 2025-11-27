import Foundation
import OSLog

// MARK: - Network Logger
final class NetworkLogger {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.cometta", category: "Network")

    init() {}

    // MARK: - Request Logging
    func logRequest(_ request: URLRequest) {
        logger.info("🌐 REQUEST")
        logger.info("URL: \(request.url?.absoluteString ?? "N/A")")
        logger.info("Method: \(request.httpMethod ?? "N/A")")

        // Log headers
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            logger.debug("Headers: \(headers.description)")
        }

        // Log body
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            logger.debug("Body: \(bodyString)")
        }
    }

    // MARK: - Response Logging
    func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        if let error = error {
            logger.error("❌ RESPONSE ERROR: \(error.localizedDescription)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            logger.warning("⚠️ Invalid response type")
            return
        }

        let statusCode = httpResponse.statusCode
        let emoji = statusCode >= 200 && statusCode < 300 ? "✅" : "❌"

        logger.info("\(emoji) RESPONSE")
        logger.info("Status Code: \(statusCode)")
        logger.info("URL: \(httpResponse.url?.absoluteString ?? "N/A")")

        // Log response data
        if let data = data {
            logger.debug("Data Size: \(data.count) bytes")

            if let jsonString = String(data: data, encoding: .utf8) {
                logger.debug("Response Body: \(jsonString)")
            }
        }
    }

    // MARK: - Error Logging
    func logError(_ error: NetworkError) {
        logger.error("🚫 Network Error: \(error.errorDescription ?? "Unknown error")")
    }
}
