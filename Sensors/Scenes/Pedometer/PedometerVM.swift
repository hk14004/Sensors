//
//  PedometerVM.swift
//  Sensors
//
//  Created by Hardijs on 02/12/2020.
//

import Foundation
import CoreMotion

class PedometerVM {
    
    weak var delegate: PedometerVMDelegate?
    
    private let cMPedometer = CMPedometer()
    
    func start() {
        delegate?.userStateChanged(isMoving: false)
        delegate?.distanceChanged(meters: 0)
        trackUserState()
        trackDistance()
    }
    
    private func trackUserState() {
        guard CMPedometer.isPedometerEventTrackingAvailable() else {
            delegate?.onError(title: "Error", message: NSLocalizedString("Pedometer is not available", comment: ""))
            return
        }
        
        cMPedometer.startEventUpdates { [unowned self] (event, error) in
            if let event = event {
                switch event.type {
                case .pause:
                    delegate?.userStateChanged(isMoving: false)
                case .resume:
                    delegate?.userStateChanged(isMoving: true)
                @unknown default:
                    break
                }
            }
            
            if let error = error {
                print(error.localizedDescription)
                delegate?.onError(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
            }
        }
    }
    
    private func trackDistance() {
        guard CMPedometer.isDistanceAvailable() else {
            delegate?.onError(title: "Error", message: NSLocalizedString("Pedometer is not available", comment: ""))
            return
        }
        
        cMPedometer.startUpdates(from: Date()) { [unowned self] (data, error) in
            if let data = data {
                delegate?.distanceChanged(meters: Double(truncating: data.distance ?? 0))
            }
            
            if let error = error {
                print(error.localizedDescription)
                delegate?.onError(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
            }
        }
    }
    
    func stop() {
        cMPedometer.stopEventUpdates()
        cMPedometer.stopUpdates()
    }
    
    func reset() {
        stop()
        delegate?.userStateChanged(isMoving: false)
        delegate?.distanceChanged(meters: 0)
        start()
    }
}

protocol PedometerVMDelegate: class {
    func userStateChanged(isMoving: Bool)
    func distanceChanged(meters: Double)
    func onError(title: String, message: String)
}
