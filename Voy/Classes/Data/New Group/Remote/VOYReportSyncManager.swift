//
//  VOYReportSyncManager.swift
//  Voy
//
//  Created by Daniel Amaral on 21/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYReportSyncManager {

    private let mediaFileDataSource: VOYMediaFileDataSource
    private let reachability: VOYReachability
    private let reportStoreManager = VOYReportStorageManager()
    private let cameraDataStoreManager = VOYCameraDataStorageManager()

    init(mediaFileDataSource: VOYMediaFileDataSource = VOYMediaFileRepository(),
         reachability: VOYReachability = VOYDefaultReachability()) {
        self.mediaFileDataSource = mediaFileDataSource
        self.reachability = reachability
    }

    func trySendPendentReports() {
        let pendentReportsJSON = reportStoreManager.getPendentReports()
        guard !pendentReportsJSON.isEmpty else {
            return
        }
        guard reachability.hasNetwork() else {
            return
        }
        for reportJSON in pendentReportsJSON {
            let report = VOYReport(JSON: reportJSON)!
            VOYAddReportRepository(reachability: reachability).save(report: report) { (_, _) in }
        }
    }

    func trySendPendentCameraData() {
        let pendentCameraDataListDictionary = cameraDataStoreManager.getPendentCameraDataList()
        var cameraDataList = [VOYCameraData]()
        guard !pendentCameraDataListDictionary.isEmpty else {
            return
        }
        for cameraDataDictionary in pendentCameraDataListDictionary {
            let cameraData = VOYCameraData(JSON: cameraDataDictionary)!
            cameraDataList.append(cameraData)
        }
        guard reachability.hasNetwork() else {
            return
        }
        guard !mediaFileDataSource.isUploading else { return }
        mediaFileDataSource.upload(reportID: 0, cameraDataList: cameraDataList) { (_) in }
    }
}
