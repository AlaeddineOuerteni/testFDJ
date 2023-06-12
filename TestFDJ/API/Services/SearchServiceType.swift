//
//  SearchServiceType.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import RxSwift

protocol SearchServiceType {
    func fetchLeagues() -> Single<LeagueListResponse>
    func fetchTeams(_ strLeague: String) -> Single<TeamListResponse>
}

final class SearchService: RestService, SearchServiceType {
    /**
     Fetch all leagues
     
     - returns: Single<LeagueListResponse>
     */
    func fetchLeagues() -> Single<LeagueListResponse> {
        let path = "all_leagues.php"
        let req = RestRequest<Data>(httpMethod: .GET, path: path)
        return requester.query(request: req)
    }

    /**
     Fetch all teams of a specific league
     
     - parameter strLeague: (path) String
     - returns: Single<TeamListResponse>
     */
    func fetchTeams(_ strLeague: String) -> Single<TeamListResponse> {
        let path = "search_all_teams.php"
        let params: [String: Any] = ["l": strLeague]
        let req = RestRequest<Data>(httpMethod: .GET, path: path, params: params)
        return requester.query(request: req)
    }
}
