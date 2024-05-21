//
//  Keychain.swift
//
//
//  Created by Usman Nazir on 20/05/2024.
//

import Foundation

protocol Keychain {

    var service: String { get }
    var account: String { get }
    
    func readDeviceId() throws -> String
    func saveDeviceId(value: String) throws
    func deleteDeviceId() throws
}
