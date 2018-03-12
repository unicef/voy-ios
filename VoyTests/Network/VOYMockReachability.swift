//
//  VOYMockReachabilityOffline.swift
//  VoyTests
//
//  Created by Dielson Sales on 09/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYMockReachability: VOYReachability {
    var mockNetworkAvailable = true
    
    func hasNetwork() -> Bool {
        return mockNetworkAvailable
    }
}
