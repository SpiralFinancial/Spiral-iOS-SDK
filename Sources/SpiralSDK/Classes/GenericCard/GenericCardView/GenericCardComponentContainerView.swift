//
//  GenericCardComponentContainerView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 7/28/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

class GenericCardComponentContainerView: GenericCardComponentView {
    
    @IBOutlet private weak var stackView: UIStackView!
        
    override func configureWith(_ data: GenericCardComponentDisplayModel) {
        super.configureWith(data)
        
        guard let containerComponentData = data.componentModel.content as? GenericCardComponentContainer else { return }
        
        if let axis = containerComponentData.axis {
            stackView.axis = axis.asStackViewAxis
        }
        
        if stackView.axis == .horizontal {
            stackView.alignment = .center
        }
        
        stackView.frame.size.width = frame.size.width
        
        stackView.removeAllArrangedSubviews()
        
        var childrenComponentViews = [GenericCardComponentView]()
        
        containerComponentData.children?.forEach {
            if let componentView =
                GenericCardViewBuilder.componentViewForModel(componentModel: $0,
                                                             deepLinker: data.deepLinker,
                                                             layoutUpdateHandler: data.layoutUpdateHandler) {
                childrenComponentViews.append(componentView)
                stackView.addArrangedSubview(componentView)
                
                componentView.layoutSubviews()
            }
        }
        
        stackView.frame.size.width = genericContentView.frame.size.width
        stackView.layoutSubviews()
        
        childrenComponentViews.forEach {
            if let componentDisplayData = $0.componentDisplayData {
                $0.configureWith(componentDisplayData)
            }
        }
        
        applyImplicitHeight()
    }
    
    func applyImplicitHeight() {
        // When contained inside a scroll container,
        // it for some reason tries to compress the stack view as much as possible.
        // This prevents that.
        if findSuperview(subclassOf: GenericCardScrollContainerView.self) != nil {
            let height = systemLayoutSizeFitting(CGSize(width: frame.size.width,
                                                                      height: UIView.layoutFittingCompressedSize.height),
                                                               withHorizontalFittingPriority: .required,
                                                               verticalFittingPriority: .defaultLow).height
            
            let heightConstraint = NSLayoutConstraint(item: self,
                                                      attribute: NSLayoutConstraint.Attribute.height,
                                                      relatedBy: NSLayoutConstraint.Relation.equal,
                                                      toItem: nil,
                                                      attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                      multiplier: 1,
                                                      constant: height)
            addConstraint(heightConstraint)
        }
    }
}
