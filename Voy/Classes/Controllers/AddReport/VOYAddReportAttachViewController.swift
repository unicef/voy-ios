//
//  VOYAddReportAttachViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAddReportAttachViewController: UIViewController {

    @IBOutlet var mediaViews:[VOYAddMediaView]!
    @IBOutlet var lbTitle:UILabel!

    init() {
        super.init(nibName: "VOYAddReportAttachViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Report"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setupMediaViewDelegate()
        addNextButton()
    }
    
    func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(openNextController))
    }
    
    @objc func openNextController() {
        self.navigationController?.pushViewController(VOYAddReportDataViewController(), animated: true)
    }
    
    func setupMediaViewDelegate() {
        for mediaView in mediaViews {
            mediaView.delegate = self
        }
    }
    
}

extension VOYAddReportAttachViewController : VOYAddMediaViewDelegate {
    func mediaViewDidTap(mediaView: VOYAddMediaView) {
        let actionSheetController = VOYActionSheetViewController(buttonNames: ["Movie","Photo"], icons: [#imageLiteral(resourceName: "noun1018049Cc"),#imageLiteral(resourceName: "noun938989Cc")])
        actionSheetController.delegate = self
        actionSheetController.show(true, inViewController: self)
    }
    func removeMediaButtonDidTap(mediaView: VOYAddMediaView) {
        
    }
}

extension VOYAddReportAttachViewController : VOYActionSheetViewControllerDelegate {
    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        //TODO: Implement actions
    }
    func cancelButtonDidTap(actionSheetViewController:VOYActionSheetViewController) {
        actionSheetViewController.close()
    }
}
