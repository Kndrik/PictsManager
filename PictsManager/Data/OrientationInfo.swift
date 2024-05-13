//
//  OrientationInfo.swift
//  PictsManager
//
//  Created by Stevens on 30/04/2024.
//

import Foundation
import SwiftUI
import CoreMotion

class OrientationInfo: ObservableObject {
    static let shared = OrientationInfo()
    private let motionManager: CMMotionManager
    var deviceOrientation: UIDeviceOrientation = .unknown

    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.2
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let accelerometerData = data {
                self.updateOrientation(accelerometerData: accelerometerData)
            }
        }
    }

    func updateOrientation(accelerometerData: CMAccelerometerData) {
        let acceleration = accelerometerData.acceleration
        if acceleration.x >= 0.75 {
            self.deviceOrientation = .landscapeLeft
        } else if acceleration.x <= -0.75 {
            self.deviceOrientation = .landscapeRight
        } else if acceleration.y <= -0.75 {
            self.deviceOrientation = .portrait
        } else if acceleration.y >= 0.75 {
            self.deviceOrientation = .portraitUpsideDown
        }
    }

    func getDeviceOrientation() -> UIDeviceOrientation {
        return self.deviceOrientation
    }
}
