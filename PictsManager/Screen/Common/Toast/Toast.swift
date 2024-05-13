//
//  ToastModel.swift
//  PictsManager
//
//  Created by Minh Duc on 18/03/2024.
//

import Foundation

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 2
    var width: Double = .infinity
}
