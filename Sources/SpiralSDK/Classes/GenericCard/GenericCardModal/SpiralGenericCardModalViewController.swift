//
//  GenericCardModalViewController.swift
//  SpiralBank
//
//  Created by Eric Collom on 3/1/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import UIKit

protocol GenericCardModalViewModelType {
    var genericCard: Observable<GenericCardDisplayModel> { get }
    var shouldRefreshLayout: Observable<Bool> { get }
    func dismissModal(controller: UIViewController)
}

class GenericModalScrollContainer: UIScrollView {
    // Used for adding spacing below 'X' button.
    // Currently generic content starts from the very top of the view
    let initialContentOffset: CGFloat = 0
}

public class SpiralGenericCardModalViewController: SpiralBaseViewController {
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    public override var showsNavigationBar: Bool { false }
    
    var viewModel: GenericCardModalViewModelType?
    private var card: GenericCardDisplayModel?
    private var currentFrame = CGRect.zero
    
    @IBOutlet weak var scrollView: GenericModalScrollContainer!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var genericCardView: SpiralGenericCardView!
    
    @IBOutlet weak var tapView: UIView!
        
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let card = card else { return }
        
        if scrollView.frame != currentFrame {
            var frame = genericCardView.frame
            frame.size.width = scrollView.bounds.width
            self.genericCardView.frame = frame
            self.genericCardView.configureWith(card)
        }
        
        let size = CGSize(width: scrollView.frame.width,
                          height: UIView.layoutFittingCompressedSize.height)
        let height = self.genericCardView.systemLayoutSizeFitting(size,
                                                                  withHorizontalFittingPriority: .required,
                                                                  verticalFittingPriority: .defaultLow).height
        self.scrollViewHeightConstraint.constant = height + self.scrollView.initialContentOffset
        
        currentFrame = scrollView.frame
        
        scrollView.isScrollEnabled = height > scrollView.frame.size.height
    }
    
    public override func viewDidLoad() {
        bindEvents()
        
        super.viewDidLoad()
    }
    
    private func bindEvents() {
        viewModel?.genericCard.bindAndFire { [weak self] card in
            
            guard let self = self else { return }
            self.card = card
        }
        
        viewModel?.shouldRefreshLayout.bind { [weak self] _ in
            self?.viewDidLayoutSubviews()
        }
    }
    
    private func setupBackground() {
        view.backgroundColor = .lightGray
        view.isOpaque = false
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        close()
    }
    
    @objc private func close() {
        viewModel?.dismissModal(controller: self)
        genericCardView.triggerRootLinks()
    }
}

extension SpiralGenericCardModalViewController {
    public class func create(with genericCard: SpiralGenericCardPayloadModel,
                      delegate: SpiralDelegate) -> SpiralGenericCardModalViewController {
        
//        let bundle = Bundle(for: self)
//        guard let bundleURL = Bundle(for: self).url(forResource: "Resources", withExtension: "bundle"),
//              let bundle = Bundle(url: bundleURL) else { return SpiralGenericCardModalViewController() }
        guard let bundle = Bundle.spiralResourcesBundle else { return SpiralGenericCardModalViewController() }
        
        let vc = SpiralGenericCardModalViewController(nibName: "\(self)", bundle: bundle)
        
//        let vc = GenericCardModalViewController()
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        let vm = SpiralGenericCardModalViewModel(genericCard: genericCard,
                                                 delegate: delegate)
        vc.viewModel = vm
        
        return vc
    }
}
