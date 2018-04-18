//
//  VOYStorageManagerTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 06/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYStorageManagerTests: XCTestCase {

    let storageManager: VOYStorageManager = VOYDefaultStorageManager()

    override func setUp() {
        super.setUp()
        storageManager.clearAllOfflineData()
    }

    /**
     * Saves a report and checks if it's actually stored in the pending list. Then removes it and checks if it has been
     * actually removed.
     */
    func testSaveAndRemoveReport() {
        let report = VOYReport()
        report.id = 20
        report.name = "Test Report"

        // Test save the report
        storageManager.addPendingReport(report)
        XCTAssertEqual(storageManager.getPendingReports().count, 1)

        // Checks if the report was stored offline
        let savedReport = storageManager.getPendingReports().first!
        let reportId = savedReport["id"] as! Int
        let reportName = savedReport["name"] as! String
        XCTAssertEqual(reportId, report.id!)
        XCTAssertEqual(reportName, report.name!)

        // Overrides the report with a new value
        report.name = "Changed name"
        storageManager.addPendingReport(report)
        XCTAssertEqual(storageManager.getPendingReports().count, 1)
        let savedReport2 = storageManager.getPendingReports().first!
        let changedReportName = savedReport2["name"] as! String
        XCTAssertEqual(reportId, report.id!)
        XCTAssertEqual(changedReportName, report.name!)

        storageManager.removeFromPendingList(report: report)
        XCTAssertEqual(storageManager.getPendingReports().count, 0)
    }

    func testSaveAndRemoveCameraData() {
        let cameraData = VOYCameraData(
                image: nil,
                thumbnail: nil,
                thumbnailFileName: "thumbnail.jpg",
                fileName: "image.jpg",
                type: .image
        )
        cameraData.id = "040"

        // Checks if the cameraData was stored offline
        storageManager.addAsPending(cameraData: cameraData, reportID: 20)
        XCTAssertEqual(storageManager.getPendingCameraData().count, 1)
        let savedCameraData = storageManager.getPendingCameraData().first!
        XCTAssertEqual(savedCameraData["id"] as! String, cameraData.id!)
        XCTAssertEqual(savedCameraData["path"] as! String, cameraData.fileName!)
        XCTAssertEqual(savedCameraData["thumbnailPath"] as! String, cameraData.thumbnailFileName!)

        // Overrides the cameraData with a chaged value
        cameraData.fileName = "image_changed.jpg"
        storageManager.addAsPending(cameraData: cameraData, reportID: 20)
        XCTAssertEqual(storageManager.getPendingCameraData().count, 1)
        let savedCameraData2 = storageManager.getPendingCameraData().first!
        XCTAssertEqual(savedCameraData2["path"] as! String, cameraData.fileName!)
    }
}