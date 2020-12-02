//
//  AccelerometerVM.swift
//  Sensors
//
//  Created by Hardijs on 02/12/2020.
//

import Foundation
import CoreMotion

class AccelerometerVM {
    
    weak var delegate: AccelerometerVMDelegate?
    
    private let motion = CMMotionManager()
    
    private let interval: TimeInterval = 10 / 60
    
    func stop() {
        motion.stopAccelerometerUpdates()
    }
    
    func start() {
        guard
            motion.isAccelerometerAvailable,
            let operationQueue = OperationQueue.current else {
            delegate?.onError(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Accelerometer not available", comment: ""))
            return
        }
        
        motion.accelerometerUpdateInterval = interval
        motion.startAccelerometerUpdates(to: operationQueue) { [unowned self] (data, error) in
            if let data = motion.accelerometerData {
                delegate?.accelerometerDataChanged(x: data.acceleration.x,
                                                   y: data.acceleration.y,
                                                   z: data.acceleration.x)
            }
            
            if let error = error {
                delegate?.onError(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
}

protocol AccelerometerVMDelegate: class {
    func accelerometerDataChanged(x: Double, y: Double, z: Double)
    func onError(title: String, message: String)
}
