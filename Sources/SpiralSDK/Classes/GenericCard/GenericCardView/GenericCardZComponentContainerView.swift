//
//  GenericCardZComponentContainerView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 10/14/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

class GenericCardZComponentContainerView: GenericCardComponentView {
    
    @IBOutlet private weak var containerView: UIView!
        
    override func configureWith(_ data: GenericCardComponentDisplayModel) {
        super.configureWith(data)
        
        guard let containerComponentData = data.componentModel.content as? SpiralGenericCardZComponentContainer else { return }
        
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
        
        childrenComponentViews.forEach {
            if let componentDisplayData = $0.componentDisplayData {
                $0.configureWith(componentDisplayData)
            }
        }
    }
}
