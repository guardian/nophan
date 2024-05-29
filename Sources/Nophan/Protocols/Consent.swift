//
//  Consent.swift
//
//
//  Created by Usman Nazir on 29/05/2024.
//

import Foundation

public struct NophanConsent {
    let jurisdiction: String
    let consent: String
    let consentUUID: String
    let cmpVersion: String
    
    var parameters: [String:String] {
        return [
            "jurisdiction": jurisdiction,
            "consent": consent,
            "consentUUID": consentUUID,
            "cmpVersion": cmpVersion
        ]
    }
}
