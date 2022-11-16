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

enum SectionIndex: Int {
    case config
    case buttons
    case impact
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case SectionIndex.config.rawValue: return data.count
        case SectionIndex.buttons.rawValue: return 3
        case SectionIndex.impact.rawValue: return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SectionIndex.config.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)

            if let textLabel = cell.textLabel {
                textLabel.text = data[indexPath.row].label + ":"
            }
            
            if let detailTextLabel = cell.detailTextLabel {
                detailTextLabel.text = data[indexPath.row].value
            }
            return cell
        }
        
        if indexPath.section == SectionIndex.buttons.rawValue {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "button-" + String(indexPath.row), for: indexPath)
            return buttonCell
        }
        
        if indexPath.section == SectionIndex.impact.rawValue {
            let impactCell = tableView.dequeueReusableCell(withIdentifier: "impactCell", for: indexPath)
            
            if impactCell.contentView.subviews.isEmpty {
                Spiral.shared.loadInstantImpactCard(into: impactCell.contentView) {
                    tableView.reloadData()
                } failure: { error in
                    print("failure: " + (error?.localizedDescription ?? ""))
                } updateLayout: {
//                    tableView.reloadData()
                    
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        self.tableView.endUpdates()
                    }
                }
            }
                        
            return impactCell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case SectionIndex.config.rawValue: return "Config"
        case SectionIndex.buttons.rawValue: return "Actions"
        case SectionIndex.impact.rawValue: return "Impact Card"
        default:
            return nil
        }

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
    
    @IBAction func handleGenericModalTap() {
//        Spiral.shared.showModalContent(type: "SR_SUMMARY", delegate: self, success: nil, failure: nil)
        
        guard let cardModel = GenericCardTestFacility.genericCardTestPayloadModel() else { return }
        
        let vc = SpiralGenericCardModalViewController.create(with: cardModel, delegate: self)
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    @IBAction func getTransactionImpact() {
        Spiral.shared.getTransactionImpact(transactionId: "TRX_00100") { [weak self] impact, error in
            if error == nil {
                let alertController = UIAlertController(title: "Transaction Impact Results",
                                                        message: impact.debugDescription,
                                                        preferredStyle: .alert)
                self?.present(alertController, animated: true)
            }
        }
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
        controller.modalPresentationStyle = .fullScreen
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

extension SpiralConfigTableViewController: SpiralGenericCardModalSceneDelegate {
    
    func genericCardModalSceneDidRequestDismiss() {
        UIApplication.topViewController()?.dismiss(animated: true)
    }
    
    func goToDeepLink(_ deepLink: DeepLink) {
        
    }
    
    
}
