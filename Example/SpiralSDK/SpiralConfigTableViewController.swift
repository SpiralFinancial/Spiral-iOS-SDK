//
//  SpiralConfigTableViewController.swift
//  SpiralSDK_Example
//
//  Created by Ron Soffer on 9/20/2022.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SpiralSDK

class ConfigField {
    var label: String
    var value: String
    
    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}

class SpiralConfigTableViewController: UITableViewController, UINavigationControllerDelegate {
    var data = [
        ConfigField(label:"mode", value:"sandbox"),
        ConfigField(label:"skip_intro_screen", value:"false"),
    ]
    let st = SpiralToken()
    var selected: Int = 0
    
    private var events = Array<EventData>()

    override func viewDidLoad() {
        super.viewDidLoad()
        st.delegate = self
        navigationController?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section >= data.count {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath)
            return buttonCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)

        if let textLabel = cell.textLabel {
            textLabel.text = data[indexPath.section].value
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard section < data.count else {
            return nil
        }
        
        return data[section].label
    }

    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section < data.count {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ConfigEntryViewController") as? ConfigEntryViewController {
                vc.data = data[indexPath.section]
                    navigationController?.pushViewController(vc, animated: true)
                }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? ConfigEntryViewController {
            vc.data = data[selected]
        }
    }
    
    @IBAction func handleFetchTap() {
        var spiralTokenAttributes = SpiralTokenAttributes()

        for cf in data {
            switch cf.label {

            case "mode":
                spiralTokenAttributes.mode = cf.value
            case "skip_intro_screen":
                spiralTokenAttributes.skip_intro_screen = cf.value.lowercased() == "true"
            default:
                print("Missing case for label: \(cf.label), value: \(cf.value)")
            }
        }

        // TODO: bring back
//        st.fetchTokenWithAttributes(spiralTokenAttributes)
        
        onComplete(spiralToken: "some_token")
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        self.tableView.reloadData()
    }
}

extension SpiralConfigTableViewController: SpiralTokenDelegate {
    func onComplete(spiralToken: String) {
        Spiral.shared.startDonationFlow(token: spiralToken, delegate: self)
    }
}

extension SpiralConfigTableViewController: SpiralDelegate {
    
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?) {
        events.append(EventData(name: name, event: event))
        
        switch name {
        case .open:
            print("onEvent(name: .open")
        case .exit:
            print("onEvent(name: .exit")
            self.dismiss(animated: true)
        case .success:
            print("onEvent(name: .success")
            self.dismiss(animated: true)
        case .error:
            print("onEvent(name: .error")
        case .close:
            print("onEvent(name: .close")
        case .initialized:
            print("onEvent(name: .initialized")
        }
    }
    
    func onReady(controller: SpiralViewController) {
        self.present(controller, animated: true)
    }
    
    func onExit(_ error: SpiralError?) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventsTableViewController") as? EventsTableViewController {
            
            vc.events = events
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print("onExit")
    }
    
    func onError(_ error: SpiralError) {
        print("onError")
    }
    
    func onSuccess(_ result: SpiralSuccessPayload) {
        print("onSuccess")
    }
}
