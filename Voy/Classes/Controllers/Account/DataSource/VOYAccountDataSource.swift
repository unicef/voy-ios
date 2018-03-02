//
//  VOYAccountDataSource.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYAccountDataSource {
    func updateUser(avatar:Int?, password:String?, completion:@escaping(Error?) -> Void)
}
