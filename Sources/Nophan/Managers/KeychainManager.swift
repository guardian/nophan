//
//  KeychainManager.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation

/// `NophanKeychainManager` is responsible for managing the storage and retrieval of
/// device IDs in the Keychain. It provides methods to read, save, and delete the
/// device ID associated with a given service and account.
internal struct NophanKeychainManager: Keychain {
    /// The service associated with the Keychain entry.
    let service: String
    
    /// The account associated with the Keychain entry.
    private(set) var account: String
    
    /// Initializes a new instance of `FPAKeychainManager`.
    ///
    /// - Parameters:
    ///   - service: The service associated with the Keychain entry.
    ///   - account: The account associated with the Keychain entry.
    init(service: String, account: String) {
        self.service = service
        self.account = account
    }
    
    /// Reads the device ID from the Keychain.
    ///
    /// - Returns: A `String` representing the device ID.
    /// - Throws: An `NophanError.KeychainError` if the device ID could not be read.
    ///
    /// Example usage:
    /// ```swift
    /// do {
    ///     let deviceId = try keychainManager.readDeviceId()
    ///     print("Device ID: \(deviceId)")
    /// } catch {
    ///     print("Failed to read device ID: \(error)")
    /// }
    /// ```
    func readDeviceId() throws -> String {
        var query = keychainIdQuery()
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound, status == noErr else { throw NophanError.KeychainError(.NoDeviceId) }
        
        guard let existingItem = queryResult as? [String: AnyObject],
              let deviceIdData = existingItem[kSecValueData as String] as? Data,
              let deviceId = String(data: deviceIdData, encoding: .utf8) else {
            throw NophanError.KeychainError(.UnexpectedData)
        }
        
        return deviceId
    }
    
    /// Saves the device ID to the Keychain.
    ///
    /// - Parameter value: The device ID to be saved.
    /// - Throws: An `NophanError.KeychainError` if the device ID could not be saved.
    ///
    /// Example usage:
    /// ```swift
    /// do {
    ///     try keychainManager.saveDeviceId(value: "device123")
    ///     print("Device ID saved successfully")
    /// } catch {
    ///     print("Failed to save device ID: \(error)")
    /// }
    /// ```
    func saveDeviceId(value: String) throws {
        var query = keychainIdQuery()
        let encodedDeviceId = value.data(using: .utf8)
        query[kSecValueData as String] = encodedDeviceId as AnyObject
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == noErr else { throw NophanError.KeychainError(.SaveDeviceIdError) }
    }
    
    /// Deletes the device ID from the Keychain.
    ///
    /// - Throws: An `NophanError.KeychainError` if the device ID could not be deleted.
    ///
    /// Example usage:
    /// ```swift
    /// do {
    ///     try keychainManager.deleteDeviceId()
    ///     print("Device ID deleted successfully")
    /// } catch {
    ///     print("Failed to delete device ID: \(error)")
    /// }
    /// ```
    func deleteDeviceId() throws {
        let query = keychainIdQuery()
        let status = SecItemDelete(query as CFDictionary)
        guard status == noErr || status == errSecItemNotFound else { throw NophanError.KeychainError(.DeletionError) }
    }
    
    /// Creates a Keychain query dictionary for the service and account.
    ///
    /// - Returns: A dictionary representing the Keychain query.
    private func keychainIdQuery() -> [String: AnyObject] {
        var query: [String: AnyObject] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        return query
    }
}
