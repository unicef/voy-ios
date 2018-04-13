//
//  VOYReportDetailsViewController.swift
//  Voy
//
//  Created by Dielson Sales on 12/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

enum VOYReportDetailsRow: String {
    case header
    case externalLinksHeader
    case externalLinksItem
    case tags
}

struct VOYReportDetailsConstants {
    static let linkCellHeight: CGFloat = 30
    static let tagsCellHeight: CGFloat = 141
}

class VOYReportDetailsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private var viewModel: VOYReportDetailsViewModel?
    private var presenter: VOYReportDetailsPresenter!

    init(report: VOYReport) {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        presenter = VOYReportDetailsPresenter(report: report, view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(
            UINib(nibName: "VOYReportDetailsHeaderCell", bundle: nil),
            forCellReuseIdentifier: VOYReportDetailsRow.header.rawValue
        )
        tableView.register(
            VOYExternalLinksHeaderCell.self,
            forCellReuseIdentifier: VOYReportDetailsRow.externalLinksHeader.rawValue
        )
        tableView.register(
            VOYExternalLinkItemCell.self,
            forCellReuseIdentifier: VOYReportDetailsRow.externalLinksItem.rawValue
        )
        tableView.register(
            UINib(nibName: "VOYReportDetailsTagsCell", bundle: nil),
            forCellReuseIdentifier: VOYReportDetailsRow.tags.rawValue
        )

        presenter.onViewDidLoad()
    }

    private func getHeaderCell() -> UITableViewCell? {
        guard let viewModel = self.viewModel else { return nil }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VOYReportDetailsRow.header.rawValue)
                as? VOYReportDetailsHeaderCell else {
            return nil
        }
        cell.setup(with: viewModel)
        return cell
    }

    private func getLinksHeader() -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VOYReportDetailsRow.externalLinksHeader.rawValue)
            as? VOYExternalLinksHeaderCell else {
            fatalError("Could not load cell")
        }
        return cell
    }

    private func getLinksItem(at position: Int) -> UITableViewCell? {
        guard let viewModel = self.viewModel else { return nil }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VOYReportDetailsRow.externalLinksItem.rawValue)
            as? VOYExternalLinkItemCell else {
            fatalError("Could not load cell")
        }
        cell.setLink(link: viewModel.links[position])
        return cell
    }

    private func getTagsViewCell() -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VOYReportDetailsRow.tags.rawValue)
            as? VOYReportDetailsTagsCell else {
            fatalError("Could not load cell")
        }
        return cell
    }
}

extension VOYReportDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = self.viewModel else { return UITableViewAutomaticDimension }
        if viewModel.links.isEmpty {
            switch indexPath.row {
            case 0:
                return UITableViewAutomaticDimension
            default:
                return VOYReportDetailsConstants.tagsCellHeight
            }
        } else {
            if indexPath.row == 0 {
                return UITableViewAutomaticDimension
            } else if indexPath.row == 1 {
                return VOYReportDetailsConstants.linkCellHeight
            } else if indexPath.row > 1 && indexPath.row < viewModel.links.count + 2 {
                return VOYReportDetailsConstants.linkCellHeight
            } else {
                return VOYReportDetailsConstants.tagsCellHeight
            }
        }
    }
}

extension VOYReportDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewModel else { return UITableViewCell() }
        var cell: UITableViewCell?

        if viewModel.links.isEmpty {
            switch indexPath.row {
            case 0:
                cell = getHeaderCell()
            case 1:
                cell = getTagsViewCell()
            default:
                break
            }
        } else {
            if indexPath.row == 0 {
                cell = getHeaderCell()
            } else if indexPath.row == 1 {
                cell = getLinksHeader()
            } else if indexPath.row > 1 && indexPath.row < viewModel.links.count + 2 {
                cell = getLinksItem(at: indexPath.row - 2)
            } else {
                cell = getTagsViewCell()
            }
        }
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        if viewModel.links.count > 0 {
            return viewModel.links.count + 3
        } else {
            return 2 // header and tags cells
        }
    }
}

extension VOYReportDetailsViewController: VOYReportDetailsContract {
    func update(with viewModel: VOYReportDetailsViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

    func setThemeColor(themeColorHex: String) {}

    func setCameraData(_ cameraDataList: [VOYCameraData]) {}

    func navigateToPictureScreen(image: UIImage) {}

    func navigateToVideoScreen(videoURL: URL) {}

    func navigateToCommentsScreen(report: VOYReport) {}

    func setCommentButtonEnabled(_ enabled: Bool) {}

    func setupNavigationButtons(avatarURL: URL, lastNotification: String?, showOptions: Bool, showShare: Bool) {}

    func navigateToEditReport(report: VOYReport) {}

    func shareText(_ string: String) {}

    func showOptions() {}

    func showIssueAlert(lastNotification: String) {}
}
