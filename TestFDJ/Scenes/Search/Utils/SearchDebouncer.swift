//
//  SearchDebouncer.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import RxSwift

protocol SearchDebouncerType {
    func debounce(subject: PublishSubject<String>) -> Observable<String>
}

final class SearchDebouncer: SearchDebouncerType {
    private let delayTimer: Int

    init(delayTimer: Int) {
        self.delayTimer = delayTimer
    }

    func debounce(subject: PublishSubject<String>) -> Observable<String> {
        subject.debounce(.milliseconds(delayTimer), scheduler: MainScheduler.instance)
    }
}
