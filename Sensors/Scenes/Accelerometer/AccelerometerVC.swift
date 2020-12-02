//
//  AccelerometerVC.swift
//  Sensors
//
//  Created by Hardijs on 01/12/2020.
//

import UIKit

class AccelerometerVC: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var xPositionLabel: UILabel!
    
    @IBOutlet weak var yPositionLabel: UILabel!
    
    @IBOutlet weak var zPositionLabel: UILabel!
    
    // MARK: Vars
    
    private let accelerometerVM = AccelerometerVM()
    
    // MARK: Functions
    
    override func viewDidLoad() {
        accelerometerVM.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accelerometerVM.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accelerometerVM.stop()
    }
}

extension AccelerometerVC: AccelerometerVMDelegate {
    func accelerometerDataChanged(x: Double, y: Double, z: Double) {
        DispatchQueue.main.async {
            self.xPositionLabel.text = String(format: "X: %.02f", x)
            self.yPositionLabel.text = String(format: "Y: %.02f", y)
            self.zPositionLabel.text = String(format: "Z: %.02f", z)
        }
    }
    
    func onError(title: String, message: String) {
        displayConfirmationAlert(title: title, message: message)
    }
}
