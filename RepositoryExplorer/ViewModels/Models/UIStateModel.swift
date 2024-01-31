//
//  UIStateModel.swift
//  RepositoryExplorer
//
//  Created by Yousuf on 1/31/24.
//

import Foundation

enum UIState : Equatable{
    case loading
    case success
    case failure(error: String)
    case empty
}
