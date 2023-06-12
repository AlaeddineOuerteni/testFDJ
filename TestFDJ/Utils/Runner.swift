//
//  Runner.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import Foundation

struct Runner {

    /**
     Runs the code block if we're in the main thread
     Otherwise the block is queued up to run after the current runloop completes (to be executed on the main queue)
     */
    static func runOnMainThread(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async {
                work()
            }
        }
    }
}
