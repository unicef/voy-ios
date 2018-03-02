//
//  VOYAccountViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandCollectionView
import NVActivityIndicatorView

class VOYAccountViewController: UIViewController, NVActivityIndicatorViewable, VOYAccountContract {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var viewUserName: VOYTextFieldView!
    @IBOutlet weak var viewEmail: VOYTextFieldView!
    @IBOutlet weak var viewPassword: VOYTextFieldView!
    @IBOutlet weak var btLogout: UIButton!
    @IBOutlet weak var btEditPassword: UIButton!
    @IBOutlet weak var collectionAvatar: ISOnDemandCollectionView!
    @IBOutlet weak var heightCollectionAvatar: NSLayoutConstraint!
    
    var rightBarButtonItem:UIBarButtonItem!
    
    var presenter: VOYAccountPresenter?
    
    var isPasswordEditing = false
    let nilPassword = "xpto321otpx"
    var newPassword:String? {
        didSet {
            enableRightBarButtonItem()
        }
    }
    var newAvatar:Int? {
        didSet {
            enableRightBarButtonItem()
        }
    }
    
    init() {
        super.init(nibName: "VOYAccountViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"
        self.presenter = VOYAccountPresenter(dataSource: VOYAccountRepository(), view: self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAvatars))
        self.imgAvatar.addGestureRecognizer(tapGesture)
        self.viewPassword.delegate = self
        setupLayout()
        setupCollectionView()
        setupData()
    }

    func enableRightBarButtonItem() {
        if newPassword == nil && newAvatar == nil {
            self.rightBarButtonItem.isEnabled = false
        }else {
            self.rightBarButtonItem.isEnabled = true
        }
    }
    
    func setupData() {
        let user = VOYUser.activeUser()!
        self.viewUserName.txtField.text = user.first_name
        self.viewUserName.layer.opacity = 0.5
        self.viewEmail.txtField.text = user.email
        self.viewEmail.layer.opacity = 0.5
        self.imgAvatar.kf.setImage(with: URL(string:user.avatar))
        self.viewPassword.txtField.text = nilPassword
        self.viewPassword.layer.opacity = 0.5
    }
    
    func setupLayout() {
        rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        rightBarButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupCollectionView() {
        collectionAvatar.register(UINib(nibName: "VOYAvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VOYAvatarCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionAvatar.setLayout(to: layout)
        collectionAvatar.onDemandDelegate = self
        collectionAvatar.interactor = VOYAvatarCollectionViewProvider()
        collectionAvatar.loadContent()
    }
    
    @objc func save() {
        if newPassword != nil || newAvatar != nil {
            self.startAnimating()
            guard let presenter = presenter else { return }
            presenter.updateUser(avatar: newAvatar, password: newPassword, completion: { (error) in
                self.stopAnimating()
                if error != nil {
                    //TODO: Show Alert
                }
            })
        }
    }
    
    @objc func showAvatars() {
        self.heightCollectionAvatar.constant = self.heightCollectionAvatar.constant == 0 ? 400 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupViewPasswordLayout() {
        self.btEditPassword.setTitle("Change", for: .normal)
        
        if isPasswordEditing {
            
            self.viewPassword.editEnabled = false
            let passwordChanged = (nilPassword != self.viewPassword.txtField.text && !self.viewPassword.txtField.text!.isEmpty)
            if passwordChanged {
                newPassword = self.viewPassword.txtField.text!
            }else {
                newPassword = nil
            }
            self.viewPassword.txtField.text = passwordChanged ? newPassword : nilPassword
            
            self.viewPassword.layer.opacity = 0.5
            self.viewPassword.txtField.resignFirstResponder()
            isPasswordEditing = false
        }else {
            self.viewPassword.editEnabled = true
            self.viewPassword.txtField.text = ""
            self.viewPassword.layer.opacity = 1
            self.viewPassword.txtField.becomeFirstResponder()
            isPasswordEditing = true
        }
    }
    
    @IBAction func btLogoutTapped() {
        VOYUser.deactiveUser()
        UIViewController.switchRootViewController(UINavigationController(rootViewController:VOYLoginViewController()), animated: true) {}
    }
    
    @IBAction func btEditPasswordTapped() {
        setupViewPasswordLayout()
    }
    
}

extension VOYAccountViewController : ISOnDemandCollectionViewDelegate {
    func onDemandCollectionView(_ collectionView: ISOnDemandCollectionView, reuseIdentifierForItemAt indexPath: IndexPath) -> String {
        return "VOYAvatarCollectionViewCell"
    }
    
    func onDemandCollectionView(_ collectionView: ISOnDemandCollectionView, onContentLoadFinishedWithNewObjects objects: [Any]?, error: Error?) {
        
    }
    
    func onDemandCollectionView(_ collectionView: ISOnDemandCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 70, height: 70)
        return size
    }
    
    func onDemandCollectionView(_ collectionView: ISOnDemandCollectionView, didSelect cell: ISOnDemandCollectionViewCell, at indexPath: IndexPath) {
        newAvatar = indexPath.item + 1
        let cell = cell as! VOYAvatarCollectionViewCell
        self.imgAvatar.image = cell.imgAvatar.image
        self.showAvatars()
    }
    
}

extension VOYAccountViewController : VOYTextFieldViewDelegate {
    func textFieldDidChange(_ textFieldView: VOYTextFieldView, text: String) {
        if !text.isEmpty {
            self.btEditPassword.setTitle("Done", for: .normal)
        }
    }
    
    func textFieldDidEndEditing(_ textFieldView: VOYTextFieldView) {
        setupViewPasswordLayout()
    }
}
