//
//  VOYThemesDataSource.swift
//  Voy
//
//  Created by Dielson Sales on 18/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYThemesDataSource {
    func getThemes(completion: ([VOYTheme]) -> Void)
}
