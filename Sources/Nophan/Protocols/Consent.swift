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
    let consentedAll: String

    public init(jurisdiction: String, 
                consent: String,
                consentUUID: String,
                cmpVersion: String,
                consentedAll: String) {
        self.jurisdiction = jurisdiction
        self.consent = consent
        self.consentUUID = consentUUID
        self.cmpVersion = cmpVersion
        self.consentedAll = consentedAll
    }
    
    var parameters: [String: String] {
        return [
            "jurisdiction": jurisdiction,
            "consent": consent,
            "consentUUID": consentUUID,
            "cmpVersion": cmpVersion,
            "consentedAll": consentedAll
        ]
    }
}
