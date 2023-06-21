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
    
    override var tableView: UITableView! {
        didSet {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action:
                                                    #selector(refresh),
                                                    for: .valueChanged)
        }
    }
    
    var data = [
        ConfigField(label:"mode", value:"sandbox"),
        ConfigField(label:"skip_intro_screen", value:"false"),
    ]
    let st = SpiralToken()
    var selected: Int = 0
    
    weak var currentlyLoadedImpactCard: UIView? = nil
    
    var customerSettings: CustomerSettings? = nil
    
    private var events = Array<EventData>()

    @objc func refresh() {
        currentlyLoadedImpactCard = nil
        
        Spiral.shared.getCustomerSettings { [weak self] customerSettings in
            self?.customerSettings = customerSettings
            
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        } failure: { error in
            print(error?.localizedDescription ?? "")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        st.delegate = self
        navigationController?.delegate = self
        
        Spiral.shared.setup(config: SpiralConfig(mode: .sandbox,
                                                 environment: .staging,
                                                 proxyAuth: SpiralProxyAuth(proxyUrl: "https://staging-api.spiral.us/passthrough/sdk",
                                                                            authToken: "737d1982-915e-47b2-a0ae-c968606606a6")
                                                 ))
        
        refresh()
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
        case SectionIndex.buttons.rawValue: return 5
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
            
            guard let customerSettings = customerSettings else {
                return UITableViewCell()
            }
            
            if currentlyLoadedImpactCard == nil {
                impactCell.contentView.subviews.forEach { $0.removeFromSuperview() }
                
                let isCustomerSponsored = customerSettings.rewardType == .userSponsored
                let hasCustomerEverOptedIn = customerSettings.userSponsoredEverOptedIn ?? false
                
                let contentType = (isCustomerSponsored && !hasCustomerEverOptedIn) ?
                GenericTemplateType.userSponsoredOptIn.rawValue :
                GenericTemplateType.srSummary.rawValue
                
                Spiral.shared.loadContentCard(type: contentType,
                                              into: impactCell.contentView,
                                              delegate: self) { impactView in
                    // Instantaneous vs. animated display
                    // tableView.reloadData()
                    
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                    
                    self.currentlyLoadedImpactCard = impactView
                    
                } failure: { error in
                    print("failure: " + (error?.localizedDescription ?? ""))
                } updateLayout: {
                    // Instantaneous vs. animated display
                    // tableView.reloadData()
                    
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
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
    
    @IBAction func handleDonationTap() {
        /*
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
        } */

        // TODO: bring back
//        st.fetchTokenWithAttributes(spiralTokenAttributes)
        
//        onComplete(spiralToken: "some_token")
        
        Spiral.shared.startSearchCharitiesFlow(delegate: self)
    }
    
    @IBAction func handleCustomerSettingsTap() {
        Spiral.shared.startCustomerSettingsFlow(delegate: self)
    }
    
    @IBAction func handleGivingCenterTap() {
        Spiral.shared.startGivingCenterFlow(delegate: self)
    }
    
    @IBAction func handleGenericModalTap() {
        Spiral.shared.showModalContent(type: "HOW_IT_WORKS", success: nil, failure: nil, delegate: self)
        
//        guard let cardModel = GenericCardTestFacility.genericCardTestPayloadModel() else { return }
//
//        let vc = SpiralGenericCardModalViewController.create(with: cardModel, delegate: self)
//        present(vc, animated: true)
    }
    
    @IBAction func getTransactionImpact() {
        Spiral.shared.getTransactionImpact(transactionId: "TRX_00100") { [weak self] impact, error in
            if error == nil, let impact = impact, let self = self {
                let alertController = UIAlertController(title: "Transaction Impact Results",
                                                        message: self.impactSummaryText(transactionReward: impact),
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction (title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
    }
    
    func plural(word: String, suffix: String, n: Double) -> String {
        return n > 1 ? word + suffix : word
    }
    
    func impactSummaryText(transactionReward: TransactionImpactResponse) -> String {
        let unit = transactionReward.rewardUnit?.unit
        let count = transactionReward.impactUnits
        
        switch unit {
        case "TREE": return "We donated to pay for \(Int(count)) \(plural(word: "tree", suffix: "s", n: count)) to clean the air."
        case "MEAL": return "We donated to pay for \(Int(count)) \(plural(word: "meal", suffix: "s", n: count)) for a child that is going hungry."
        case "CLEAN_WATER": return "We donated to pay for \(Int(count)) \(plural(word: "week", suffix: "s", n: count)) of clean water for a person in need."
        case "SAFE_SHELTER": return "We donated to pay for \(Int(count)) \(plural(word: "night", suffix: "s", n: count)) of safe shelter for a person in poverty."
        case .none:
            return ""
        case .some(_):
            return ""
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        self.tableView.reloadData()
    }
}

extension SpiralConfigTableViewController: SpiralTokenDelegate {
    func onComplete(spiralToken: String) {
        Spiral.shared.startSearchCharitiesFlow(delegate: self)
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
    
    func onBeginLoadingContent() {
        print("Spiral begin loading content")
    }
    
    func onFinishLoadingContent() {
        print("Spiral end loading content")
    }
    
    func onReady(controller: SpiralViewController) {
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    func onFailedToStart(_ error: SpiralError) {
        print("onFailedToStart: " + error.message)
    }
    
    func onExit(_ error: SpiralError?) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventsTableViewController") as? EventsTableViewController {
            
            vc.events = events
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print("onExit")
    }
    
    func onError(_ error: SpiralError) {
        print("onError: " + error.message)
    }
    
    func onSuccess(_ result: SpiralSuccessPayload) {
        print("onSuccess")
        
        refresh()
    }
    
}

extension SpiralConfigTableViewController: SpiralDeepLinkHandler {
    
    func handleDeepLink(_ deepLink: SpiralDeepLink) -> Bool {
        return false
    }
}
