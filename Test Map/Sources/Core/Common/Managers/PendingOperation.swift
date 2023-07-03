//
//  PendingOperation.swift
//  Test Map
//
//  Created by Melany Gulianovych on 03.07.2023.
//

import Foundation

class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
