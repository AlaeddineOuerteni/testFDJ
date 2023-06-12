//
//  SearchDataLogicMock.swift
//  TestFDJTests
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import RxSwift
@testable import TestFDJ

final class SearchDataLogicMock: SearchDataLogicType {
    func fetchLeagues() -> Single<[LeagueDataModel]> {
        .just(LeagueDataModel.Mock.build())
    }

    func fetchTeams(_ strLeague: String) -> Single<[TeamDataModel]> {
        .just(TeamDataModel.Mock.build())
    }
}
