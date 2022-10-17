//
//  GenericCardScrollContainerView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 3/16/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation

class GenericCardScrollContainerView: GenericCardComponentView {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
        
    override func configureWith(_ data: GenericCardComponentDisplayModel) {
        super.configureWith(data)
        
        guard let containerComponentData = data.componentModel.content as? GenericCardScrollComponentContainer else { return }
        
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        var childrenComponentViews = [GenericCardComponentView]()
        
        containerComponentData.children?.forEach {
            if let componentView =
                GenericCardViewBuilder.componentViewForModel(componentModel: $0,
                                                             deepLinker: data.deepLinker,
                                                             layoutUpdateHandler: data.layoutUpdateHandler) {
                childrenComponentViews.append(componentView)
                containerView.addSubview(componentView)
                
                componentView.translatesAutoresizingMaskIntoConstraints = false
                componentView.frame = containerView.bounds
                
                GenericCardViewBuilder.installEdgeSnapConstraints(view: componentView,
                                                                  superview: containerView,
                                                                  edges: $0.snapToEdges)
                
                componentView.layoutSubviews()
            }
        }
        
        containerView.frame.size.width = genericContentView.frame.size.width
        containerView.layoutSubviews()
        
        scrollView.frame.size.width = genericContentView.frame.size.width
        scrollView.layoutSubviews()
        
        childrenComponentViews.forEach {
            if let componentDisplayData = $0.componentDisplayData {
                $0.configureWith(componentDisplayData)
            }
        }
    }
    
    override func applyFixedDimensions() {
        super.applyFixedDimensions()
        
        guard let scrollView = scrollView else { return }
        
        if !heightConstraint.isActive {
            if let modalScrollView = findSuperview(subclassOf: GenericModalScrollContainer.self) {
                let constraint = NSLayoutConstraint(item: scrollView,
                                                    attribute: .height,
                                                    relatedBy: .lessThanOrEqual,
                                                    toItem: modalScrollView,
                                                    attribute: .height,
                                                    multiplier: 1.0,
                                                    constant: -(modalScrollView.initialContentOffset))
                constraint.isActive = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if scrollView.contentSize.height > scrollView.frame.size.height {
            scrollView.flashScrollIndicators()
        }
    }
}
