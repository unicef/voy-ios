//
//  VOYReportSyncManager.swift
//  Voy
//
//  Created by Daniel Amaral on 21/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYReportSyncManager: NSObject {

    static let shared = VOYReportSyncManager()
    
    func trySendPendentReports() {
        let pendentReportsJSON = VOYReportStorageManager.shared.getPendentReports()
        guard !pendentReportsJSON.isEmpty else {
            return
        }
        
        guard NetworkReachabilityManager()!.isReachable else {
            return
        }
        
        for reportJSON in pendentReportsJSON {
            let report = VOYReport(JSON: reportJSON)!
            VOYAddReportRepository(reachability: VOYReachabilityImpl()).save(report: report, completion: { (error, reportID) in })
        }
    }
    
    func trySendPendentCameraData() {
        let pendentCameraDataListDictionary = VOYCameraDataStorageManager.shared.getPendentCameraDataList()
        var cameraDataList = [VOYCameraData]()
        
        guard !pendentCameraDataListDictionary.isEmpty else {
            return
        }
        
        for cameraDataDictionary in pendentCameraDataListDictionary {
            let cameraData = VOYCameraData(JSON:cameraDataDictionary)!
            cameraDataList.append(cameraData)
        }
        
        guard NetworkReachabilityManager()!.isReachable else {
            return
        }
        
        guard !VOYMediaFileRepository.isUploading else { return }
        
        VOYMediaFileRepository.shared.upload(reportID: 0, cameraDataList: cameraDataList) { (_) in }
    }
    
}
