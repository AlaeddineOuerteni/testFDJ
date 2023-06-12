//
//  TranslatorType.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import Foundation

/// Interface that provide a way to localize a string.
protocol TranslatorType {

    /// Localize a string
    /// - Parameters:
    ///   - key: Key to find the appropriate localized string.
    func localizeString(key: String) -> String
}

final class Translator: TranslatorType {
    func localizeString(key: String) -> String {
        NSLocalizedString(key, comment: key)
    }
}
