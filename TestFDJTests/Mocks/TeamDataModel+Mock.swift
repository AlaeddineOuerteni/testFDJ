//
//  TeamDataModel+Mock.swift
//  TestFDJTests
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import XCTest
@testable import TestFDJ

extension TeamDataModel {
    enum Mock {
        static func build() -> [TeamDataModel] {
            [
                TeamDataModel(strTeamLogo: "https://fdg.fr/image.png"),
                TeamDataModel(strTeamLogo: "https://fdg.fr/image.png"),
                TeamDataModel(strTeamLogo: "https://fdg.fr/image.png")
            ]
        }
    }
}
