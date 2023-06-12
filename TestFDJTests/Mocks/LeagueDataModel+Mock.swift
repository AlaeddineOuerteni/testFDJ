//
//  LeagueDataModel+Mock.swift
//  TestFDJTests
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import XCTest
@testable import TestFDJ

extension LeagueDataModel {
    enum Mock {
        static func build() -> [LeagueDataModel] {
            [
                LeagueDataModel(strLeague: "Ligue 1", strLeagueAlternate: "Ligue 1"),
                LeagueDataModel(strLeague: "Premier League", strLeagueAlternate: "Premier League"),
                LeagueDataModel(strLeague: "Liga Espanola", strLeagueAlternate: "Liga Espanola"),
                LeagueDataModel(strLeague: "Bundes Liga", strLeagueAlternate: "Bundes Liga")
            ]
        }
    }
}
