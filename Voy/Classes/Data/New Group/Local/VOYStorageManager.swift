//
//  VOYStorageManager.swift
//  Voy
//
//  Created by Dielson Sales on 06/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYStorageManager {
    func getPendingCameraData() -> [[String: Any]]
    func removeFromPendingList(cameraData: VOYCameraData)
    func addAsPending(cameraData: VOYCameraData, reportID: Int)
    func clearStoredCameraData()
    func getPendingReports() -> [[String: Any]]
    func removeFromPendingList(report: VOYReport)
    func clearPendentReports()
    func addPendingReport(_ report: VOYReport)
    func clearAllStoredData()
}
