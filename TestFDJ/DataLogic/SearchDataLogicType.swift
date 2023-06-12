//
//  SearchDataLogicType.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//
import RxSwift

protocol SearchDataLogicType {
    func fetchLeagues() -> Single<[LeagueDataModel]>
    func fetchTeams(_ strLeague: String) -> Single<[TeamDataModel]>
}

final class SearchDataLogic: SearchDataLogicType {
    enum DataLogicError: Error {
        case notRetained
    }

    private let searchService: SearchServiceType

    init(searchService: SearchServiceType = SearchService()) {
        self.searchService = searchService
    }

    func fetchLeagues() -> Single<[LeagueDataModel]> {
        searchService
            .fetchLeagues()
            .map { response in
                response.leagues.map {
                    LeagueDataModel(strLeague: $0.strLeague, strLeagueAlternate: $0.strLeagueAlternate)
                }
            }
    }
    
    func fetchTeams(_ strLeague: String) -> Single<[TeamDataModel]> {
        searchService
            .fetchTeams(strLeague)
            .map { response in
                response.teams.map {
                    TeamDataModel(strTeamLogo: $0.strTeamBadge)
                }
            }
    }
}
