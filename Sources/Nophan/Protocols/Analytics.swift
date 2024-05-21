//
//  Analytics.swift
//
//
//  Created by Usman Nazir on 20/05/2024.
//

import Foundation

protocol Analytics {
    
    var configuration: NophanConfiguration? { get }
    
    func setup(configuration: NophanConfiguration)
    func setUserIdentifier(id: NophanUserId)
    
    func trackEvent(_ event: NophanEventRepresentable)
    func trackConfiguration()
    func trackUser()
    
    func prepareRequest(for event: NophanEventRepresentable) throws -> NophanRequest
    func prepareRequest(for configuration: NophanConfiguration) -> NophanRequest
    func prepareRequest(for userId: NophanUserId) throws -> NophanRequest
}
