//
//  VOYReportDetailsViewModel.swift
//  Voy
//
//  Created by Dielson Sales on 13/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

struct VOYReportDetailsViewModel {
    let medias: [VOYMedia]
    let title: String
    let date: String
    let description: String
    let tags: [String]
    let links: [String]
    let commentsCount: Int
}
