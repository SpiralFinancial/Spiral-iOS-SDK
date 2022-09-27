//
//  ConfigEntryViewController.swift
//  SpiralSDK_Example
//
//  Created by Ron Soffer on 9/20/2022.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class ConfigEntryViewController: UIViewController, UITextFieldDelegate {

    var data: ConfigField?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let d = self.data {
            label.text = d.label
            textField.text = d.value
        }
    }
    
    
    @IBAction func handleValueChanged(_ sender: UITextField) {
        if let d = self.data, let t = sender.text {
            d.value = t
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
