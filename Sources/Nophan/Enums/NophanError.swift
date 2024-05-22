//
//  Error.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation

/// `NophanError` defines the possible errors that can occur within the FPA system.
///
/// - `ConfigurationError`: Indicates an error related to configuration.
/// - `TrackingError`: Indicates an error related to event tracking.
/// - `DeviceIdError`: Indicates an error related to the device ID.
/// - `NetworkRequestError`: Indicates an error related to network requests.
/// - `UserIdError`: Indicates an error related to the user ID.
/// - `KeychainError`: Indicates an error related to Keychain operations. Associated with a specific `KeychainErrorCase`.
public enum NophanError: Error, Equatable {
    
    /// Indicates an error related to configuration.
    case ConfigurationError
    
    /// Indicates an error related to event tracking.
    case TrackingError
    
    /// Indicates an error related to the device ID.
    case DeviceIdError
    
    /// Indicates an error related to network requests.
    case NetworkRequestError
    
    /// Indicates an error related to the user ID.
    case UserIdError
    
    /// Indicates an error related to Keychain operations.
    /// - Parameter KeychainErrorCase: The specific case of the Keychain error.
    case KeychainError(KeychainErrorCase)
    
    /// `KeychainErrorCase` defines the specific errors that can occur during Keychain operations.
    ///
    /// - `NoDeviceId`: Indicates that no device ID was found in the Keychain.
    /// - `UnexpectedData`: Indicates that the data found in the Keychain is unexpected.
    /// - `SaveDeviceIdError`: Indicates an error occurred while saving the device ID to the Keychain.
    /// - `DeletionError`: Indicates an error occurred while deleting from the Keychain.
    public enum KeychainErrorCase: Error {
        
        /// Indicates that the Keychain is not configured properly
        case Unconfigured
        
        /// Indicates that no device ID was found in the Keychain.
        case NoDeviceId
        
        /// Indicates that the data found in the Keychain is unexpected.
        case UnexpectedData
        
        /// Indicates an error occurred while saving the device ID to the Keychain.
        case SaveDeviceIdError
        
        /// Indicates an error occurred while deleting from the Keychain.
        case DeletionError
    }
}
