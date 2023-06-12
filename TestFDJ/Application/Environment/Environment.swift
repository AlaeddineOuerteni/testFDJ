//
//  Environment.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

struct Environment {
    /// Translator
    let translator: TranslatorType

    init(translator: TranslatorType = Translator()) {
        self.translator = translator
    }
}
