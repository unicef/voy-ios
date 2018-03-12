//
//  VOYNotificationViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYNotificationViewController: UIViewController, VOYNotificationContract {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: VOYNotificationPresenter?
    
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    internal func setupController() {
        lbTitle.text = localizedString(.notifications)
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: VOYNotificationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: VOYNotificationTableViewCell.identifier)
        presenter = VOYNotificationPresenter(dataSource: VOYNotificationRepository(reachability: VOYReachabilityImpl()) , view: self)
        guard let presenter = self.presenter else { return }
        presenter.viewDidLoad()
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
}

extension VOYNotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notificationList = self.presenter?.notifications else { return 0 }
        return notificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VOYNotificationTableViewCell.identifier,
                                                       for: indexPath) as? VOYNotificationTableViewCell else {
                                                        return VOYNotificationTableViewCell() }
        guard let presenter = self.presenter else { return cell }
        cell.tvNotificationBody.text = presenter.setupNotificationTitleFor(indexPath: indexPath)
        return cell
    }
}

extension VOYNotificationViewController: UITableViewDelegate {
    
}
