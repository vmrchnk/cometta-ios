import Foundation
import OSLog

struct StorageHelper {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Cometta", category: "StorageHelper")
    
    enum StorageError: Error {
        case fileNotFound
        case encodingFailed
        case decodingFailed
        case deletionFailed
        case urlConstructionFailed(String)
    }

    /// Saves a Codable object to a file in the specified directory.
    /// - Parameters:
    ///   - object: The object to save.
    ///   - fileName: The name of the file (including extension, e.g., "user.json").
    ///   - directory: The search path directory (default: .applicationSupportDirectory).
    static func save<T: Encodable>(_ object: T, to fileName: String, in directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) throws {
        guard let url = fileURL(for: fileName, in: directory) else {
            logger.error("Failed to construct URL for file: \(fileName)")
            throw StorageError.urlConstructionFailed(fileName)
        }
        
        // Ensure directory exists
        let folderURL = url.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
                logger.info("Created missing directory: \(folderURL.path)")
            } catch {
                logger.error("Failed to create directory: \(error.localizedDescription)")
                throw error
            }
        }
        
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url, options: .atomic)
            logger.info("Successfully saved \(String(describing: T.self)) to \(url.path)")
        } catch {
            logger.error("Failed to save \(fileName): \(error.localizedDescription)")
            throw StorageError.encodingFailed
        }
    }

    /// Loads a Codable object from a file.
    /// - Parameters:
    ///   - type: The type to decode.
    ///   - fileName: The name of the file.
    ///   - directory: The search path directory.
    static func load<T: Decodable>(_ type: T.Type, from fileName: String, in directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) throws -> T {
        guard let url = fileURL(for: fileName, in: directory) else {
            logger.error("Failed to construct URL for file: \(fileName)")
            throw StorageError.urlConstructionFailed(fileName)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            logger.info("Successfully loaded \(String(describing: T.self)) from \(fileName)")
            return object
        } catch {
            let nsError = error as NSError
            if nsError.domain == NSCocoaErrorDomain && nsError.code == NSFileReadNoSuchFileError {
                logger.info("File not found: \(fileName) (clean state)")
                throw StorageError.fileNotFound
            } else {
                logger.error("Failed to load \(fileName): \(error.localizedDescription)")
                throw StorageError.decodingFailed
            }
        }
    }

    /// Deletes a file.
    static func delete(_ fileName: String, in directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) throws {
        guard let url = fileURL(for: fileName, in: directory) else {
            logger.error("Failed to construct URL for file: \(fileName)")
            throw StorageError.urlConstructionFailed(fileName)
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
                logger.info("Successfully deleted \(fileName)")
            } catch {
                logger.error("Failed to delete \(fileName): \(error.localizedDescription)")
                throw StorageError.deletionFailed
            }
        } else {
            logger.info("File \(fileName) already does not exist")
        }
    }

    private static func fileURL(for fileName: String, in directory: FileManager.SearchPathDirectory) -> URL? {
        FileManager.default.urls(for: directory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }
}
