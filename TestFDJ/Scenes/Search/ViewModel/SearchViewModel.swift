//
//  SearchViewModel.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import RxRelay
import RxSwift

final class SearchViewModel {
    var onTeamsDataChanged: (() -> Void)?
    let dataLogic: SearchDataLogicType
    let translator: TranslatorType

    private(set) var teamCellViewModels: [TeamCellViewModel]? {
        didSet {
            onTeamsDataChanged?()
        }
    }
    private var leaguesDataModel: [LeagueDataModel] = []
    private let disposeBag: DisposeBag
    private let searchDebouncer: SearchDebouncerType
    private let searchPublisher = PublishSubject<String>()

    init(
        dataLogic: SearchDataLogicType = SearchDataLogic(),
        disposeBag: DisposeBag = DisposeBag(),
        searchDebouncer: SearchDebouncerType = SearchDebouncer(delayTimer: 1000),
        translator: TranslatorType = AppEnvironment.current.translator
    ) {
        self.dataLogic = dataLogic
        self.disposeBag = disposeBag
        self.searchDebouncer = searchDebouncer
        self.translator = translator
        fetchLeagues()
        subscribeToAutoCompletePublisher()
    }

    func onSearchChanged(_ keyword: String?) {
        guard let value = keyword, !value.isEmpty else {
            teamCellViewModels = nil
            return
        }
        searchPublisher.onNext(value)
    }

    private func subscribeToAutoCompletePublisher() {
        searchDebouncer.debounce(subject: searchPublisher)
            .subscribe { [weak self] query in
                guard let self = self else { return }
                guard let strLeague = self.findStrLeague(query) else { return }
                self.fetchTeams(strLeague)
            }
            .disposed(by: disposeBag)
    }

    private func fetchLeagues() {
        dataLogic.fetchLeagues().subscribe(
            onSuccess: { [weak self] response in
                self?.leaguesDataModel = response
            },
            onError: { _ in }
        ).disposed(by: disposeBag)
    }

    private func findStrLeague(_ keyword: String) -> String? {
        leaguesDataModel.first(
            where: {
                $0.strLeague.lowercased().contains(keyword.lowercased())
                ||
                $0.strLeagueAlternate?.lowercased().contains(keyword.lowercased()) ?? false
            }
        )?.strLeague
    }

    private func fetchTeams(_ strLeague: String) {
        dataLogic.fetchTeams(strLeague).subscribe(
            onSuccess: { [weak self] response in
                self?.teamCellViewModels = response.map { TeamCellViewModel(logoUrl: $0.strTeamLogo)}
            },
            onError: { _ in }
        ).disposed(by: disposeBag)
    }
}
