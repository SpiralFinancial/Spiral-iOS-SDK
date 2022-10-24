//
//  GenericCardView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 7/26/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation
import UIKit

public struct GenericCardDisplayModel {
    let cardData: GenericCardPayloadModel
    weak var deepLinker: DeepLinkable?
    let layoutUpdateHandler: (_ constraintUpdater: @escaping () -> Void) -> Void
    
    public init(cardData: GenericCardPayloadModel, deepLinker: DeepLinkable? = nil, layoutUpdateHandler: @escaping (@escaping () -> Void) -> Void) {
        self.cardData = cardData
        self.deepLinker = deepLinker
        self.layoutUpdateHandler = layoutUpdateHandler
    }
}

public struct GenericCardComponentDisplayModel {
    let componentModel: GenericCardComponent
    weak var deepLinker: DeepLinkable?
    let layoutUpdateHandler: (_ constraintUpdater: @escaping () -> Void) -> Void
}

class GenericCardComponentView: BaseView, Configurable {
    @IBOutlet var genericContentView: UIView!
    @IBOutlet var leftPaddingConstraint: NSLayoutConstraint!
    @IBOutlet var rightPaddingConstraint: NSLayoutConstraint!
    @IBOutlet var topPaddingConstraint: NSLayoutConstraint!
    @IBOutlet var bottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    var componentModel: GenericCardComponent?
    var componentDisplayData: GenericCardComponentDisplayModel?
    var deepLinks = [DeepLink]()
    
    private var tapGestureRecognizer: BindableTapGestureRecognizer?
    
    func configureWith(_ data: GenericCardComponentDisplayModel) {
        self.componentModel = data.componentModel
        self.componentDisplayData = data
        
        setBackgroundColor(colorHex: componentModel?.backgroundColor)
        setAlpha(alpha: componentModel?.alpha)
        setBlur(componentModel?.blur)
        
        if let currentRecognizer = tapGestureRecognizer {
            removeGestureRecognizer(currentRecognizer)
            tapGestureRecognizer = nil
        }
        
        deepLinks.removeAll()
        
        if let linkStr = componentModel?.link,
            let deepLink = DeepLink(from: linkStr) {
            deepLinks.append(deepLink)
        }
        
        if let links = componentModel?.links {
            links.forEach {
                if let deepLink = DeepLink(from: $0) {
                    deepLinks.append(deepLink)
                }
            }
        }
        
        // Modal Links only get triggered when user closes out
        // via X button or tapping outside of content view
        if !deepLinks.isEmpty && data.componentModel.type != .modal {
            addDeepLinkHandler()
        }
        
        applyFixedDimensions()
        
        applyPadding()
        
        frame.size.width = superview?.frame.size.width ?? 0
        genericContentView.frame.size.width = frame.size.width -
            (leftPaddingConstraint.constant + rightPaddingConstraint.constant)
    }
    
    open func applyPadding() {
        if let padding = componentModel?.padding {
            leftPaddingConstraint.constant = padding.left
            rightPaddingConstraint.constant = padding.right
            topPaddingConstraint.constant = padding.top
            bottomPaddingConstraint.constant = padding.bottom
        }
    }
    
    open func applyFixedDimensions() {
        if let fixedWidth = componentModel?.fixedWidth {
            widthConstraint.constant = fixedWidth
            widthConstraint.isActive = true
        } else {
            widthConstraint.isActive = false
        }

        if let fixedHeight = componentModel?.fixedHeight {
            heightConstraint.constant = fixedHeight
            heightConstraint.isActive = true
        } else {
            heightConstraint.isActive = false
        }
    }
    
    open func addDeepLinkHandler() {
        if let existingRecognizer = tapGestureRecognizer {
            removeGestureRecognizer(existingRecognizer)
        }
        
        let tapRecognizer = BindableTapGestureRecognizer(action: { [weak self] in
            guard let deepLinks = self?.deepLinks else { return }
            self?.componentDisplayData?.deepLinker?.handleDeepLinks(deepLinks)
        })
        
        tapGestureRecognizer = tapRecognizer
        addGestureRecognizer(tapRecognizer)
    }
    
    open func setBackgroundColor(colorHex: String?) {
        if let bgColorHex = colorHex,
           let backgroundColorVal = UIColor(hexString: bgColorHex) {
            genericContentView.backgroundColor = backgroundColorVal
        } else {
            genericContentView.backgroundColor = .clear
        }
    }
    
    open func setAlpha(alpha: CGFloat?) {
        if let alpha = alpha {
            genericContentView.alpha = alpha
        } else {
            genericContentView.alpha = 1
        }
    }
    
    open func setBlur(_ shouldBlur: Bool?) {
        let currentBlur = findViews(subclassOf: SpiralBlurEffectView.self).first
        currentBlur?.removeFromSuperview()
        
        if let shouldBlur = shouldBlur,
            shouldBlur {
            let blur = SpiralBlurEffectView(style: .light, intensity: 0.01)
            blur.shouldAnimate = false
            blur.embed(in: self)
        }
    }
}

public class GenericCardView: BaseView, Configurable, UIGestureRecognizerDelegate {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var backgroundImageView: UIImageView!
    
    let imageDownloader: SpiralImageDownloadService = SpiralImageDownloadManager()
    
    private var tapGestureRecognizer: BindableTapGestureRecognizer?
    
    private var data: GenericCardDisplayModel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func configureWith(_ data: GenericCardDisplayModel) {
        self.data = data
        
        let cardDisplayData = data.cardData.data
        
        if let bgColorHex = cardDisplayData.backgroundColor,
           let backgroundColorVal = UIColor(hexString: bgColorHex) {
            backgroundColor = backgroundColorVal
        }
        
        if let backgroundImage = cardDisplayData.backgroundImage {
            imageDownloader.populateImageView(backgroundImageView,
                                              urlString: backgroundImage,
                                              placeholderImage: nil)
            containerView.backgroundColor = .clear
        } else {
            containerView.backgroundColor = .white
        }
        
        containerView.subviews.forEach { $0.removeFromSuperview() }
                
        frame.size.width = superview?.frame.size.width ?? 0
        containerView.frame.size.width = frame.size.width
        
        let rootModel = cardDisplayData.root

        if let rootView =
            GenericCardViewBuilder.componentViewForModel(componentModel: rootModel,
                                                         deepLinker: data.deepLinker,
                                                         layoutUpdateHandler: data.layoutUpdateHandler) {
            rootView.embed(in: containerView)
            rootView.frame.size.width = containerView.frame.size.width

            if let componentDisplayModel = rootView.componentDisplayData {
                rootView.configureWith(componentDisplayModel)
            }
        }
        
        if let deepLinkStr = cardDisplayData.link,
           let deepLink = DeepLink(from: deepLinkStr) {
            addDeepLinkHandler(deepLink: deepLink)
        }
    }
    
    open func addDeepLinkHandler(deepLink: DeepLink) {
        if let existingRecognizer = tapGestureRecognizer {
            removeGestureRecognizer(existingRecognizer)
        }
        
        let tapRecognizer = BindableTapGestureRecognizer(action: { [weak self] in
            self?.data?.deepLinker?.goToDeepLink(deepLink)
        })
        tapRecognizer.delegate = self
        tapGestureRecognizer = tapRecognizer
        addGestureRecognizer(tapRecognizer)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func triggerRootLinks() {
        var links: [DeepLink] = data?.cardData.data.root.links?.compactMap { DeepLink(from: $0) } ?? []
        if let link = data?.cardData.data.root.link,
           let deepLink = DeepLink(from: link) {
            links.append(deepLink)
        }
        
        for link in links {
            self.data?.deepLinker?.goToDeepLink(link)
        }
    }
    
    public func refreshDisplay() {
        if let cardData = data {
            configureWith(cardData)
        }
    }
}

class GenericCardViewBuilder {
    static func componentViewForModel(componentModel: GenericCardComponent,
                                      deepLinker: DeepLinkable?,
                                      layoutUpdateHandler: @escaping (_ constraintUpdater: @escaping () -> Void) -> Void) -> GenericCardComponentView? {
        var componentView: GenericCardComponentView?
        
        if componentModel.content is GenericCardComponentContainer {
            componentView = GenericCardComponentContainerView()
        } else if componentModel.content is GenericCardScrollComponentContainer {
            componentView = GenericCardScrollContainerView()
        } else if componentModel.content is GenericCardZComponentContainer {
            componentView = GenericCardZComponentContainerView()
        } else if componentModel.content is GenericCardImageComponent {
            componentView = GenericCardImageView()
        } else if componentModel.content is GenericCardButtonComponent {
            componentView = GenericCardButtonView()
        } else if componentModel.content is GenericCardTextComponent {
            componentView = GenericCardTextView()
        } else if componentModel.content is GenericCardHtmlComponent {
            componentView = GenericCardHtmlView()
        }
        
        let componentDisplayModel = GenericCardComponentDisplayModel(componentModel: componentModel,
                                                                     deepLinker: deepLinker,
                                                                     layoutUpdateHandler: layoutUpdateHandler)
        
        componentView?.componentDisplayData = componentDisplayModel
        return componentView
    }
    
    static func installEdgeSnapConstraints(view: UIView, superview: UIView, edges: [GenericCardSnapEdge]?) {
        let edges = edges ?? [.left, .right, .top, .bottom]
        
        if edges.contains(.left) {
            installEdgeConstraint(view: view, superview: superview, attribute: .leading)
        }
        if edges.contains(.right) {
            installEdgeConstraint(view: view, superview: superview, attribute: .trailing)
        }
        if edges.contains(.top) {
            installEdgeConstraint(view: view, superview: superview, attribute: .top)
        }
        if edges.contains(.bottom) {
            installEdgeConstraint(view: view, superview: superview, attribute: .bottom)
        }
    }
    
    static func installEdgeConstraint(view: UIView, superview: UIView, attribute: NSLayoutConstraint.Attribute) {
        let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: superview, attribute: attribute, multiplier: 1.0, constant: 0)
        constraint.isActive = true
    }
}
