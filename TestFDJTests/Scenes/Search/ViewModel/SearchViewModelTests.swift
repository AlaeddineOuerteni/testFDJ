//
//  SearchViewModelTests.swift
//  TestFDJTests
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import Quick
import Nimble

@testable import TestFDJ

final class SearchViewModelTests: QuickSpec {
    override func spec() {
        describe("Given a SearchViewModel") {
            context("When teams cellViewModels are changed") {
                testOnTeamsCellViewModelsChanged()
            }
        }
    }

    private func testOnTeamsCellViewModelsChanged() {
        it("Then it should call onTeamsDataChanged") {
            let viewModel = SearchViewModel(
                dataLogic: SearchDataLogicMock(),
                searchDebouncer: SearchDebouncer(delayTimer: 0)
            )

            var teamsDataChangedCount = 0
            viewModel.onTeamsDataChanged = {
                teamsDataChangedCount += 1
            }
            expect(teamsDataChangedCount).to(equal(0))
            expect(viewModel.teamCellViewModels?.isEmpty ?? true).to(beTrue())
            
            viewModel.onSearchChanged("Ligue 1")
            expect(teamsDataChangedCount).to(equal(1))
            expect(viewModel.teamCellViewModels?.isEmpty ?? true).to(beFalse())

            viewModel.onSearchChanged("")
            expect(teamsDataChangedCount).to(equal(1))
            expect(viewModel.teamCellViewModels?.isEmpty ?? true).to(beTrue())
        }
    }
}
