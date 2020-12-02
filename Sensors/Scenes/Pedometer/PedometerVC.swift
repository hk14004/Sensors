//
//  PedometerVC.swift
//  Sensors
//
//  Created by Hardijs on 02/12/2020.
//

import UIKit

class PedometerVC: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var traveledLabel: UILabel!
    
    @IBOutlet weak var walkingStateLebel: UILabel!
        
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: Vars
    
    private let pedometerVM = PedometerVM()
    
    // MARK: Functions
    
    override func viewDidLoad() {
        pedometerVM.delegate = self
        pedometerVM.start()
    }
    
    @IBAction func onResetPressed(_ sender: UIButton) {
        pedometerVM.reset()
    }
}

extension PedometerVC: PedometerVMDelegate {
    func userStateChanged(isMoving: Bool) {
        DispatchQueue.main.async {
            if isMoving {
                self.walkingStateLebel.text = NSLocalizedString("Moving", comment: "")
            } else {
                self.walkingStateLebel.text = NSLocalizedString("Still", comment: "")
            }
        }
    }
    
    func distanceChanged(meters: Double) {
        DispatchQueue.main.async {
            self.traveledLabel.text = String(format: "%.02f", meters)
        }
    }
    
    func onError(title: String, message: String) {
        displayConfirmationAlert(title: title, message: message)
    }
    
}
