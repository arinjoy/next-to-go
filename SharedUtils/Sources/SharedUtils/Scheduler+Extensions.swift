//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation

final class Scheduler {

    static var background: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let main = RunLoop.main
}
