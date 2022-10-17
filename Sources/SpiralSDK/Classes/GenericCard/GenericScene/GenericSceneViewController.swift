//
//  GenericSceneViewController.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 28.06.22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import UIKit

class GenericSceneViewController: BaseViewController {
    
    private var sceneData: GenericCardDisplayModel?
    private var currentFrame = CGRect.zero
    
    @IBOutlet weak var scrollView: GenericModalScrollContainer!
    @IBOutlet weak var genericContentView: GenericCardView!
    @IBOutlet weak var genericContentConstraint: NSLayoutConstraint!
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let sceneData = sceneData else { return }
        
        if scrollView.frame != currentFrame {
            var frame = genericContentView.frame
            frame.size.width = scrollView.bounds.width
            self.genericContentView.frame = frame
            self.genericContentView.configureWith(sceneData)
            
        }
        
        currentFrame = scrollView.frame
        
        let size = CGSize(width: scrollView.frame.width,
                          height: UIView.layoutFittingCompressedSize.height)
        let height = self.genericContentView.systemLayoutSizeFitting(size,
                                                                     withHorizontalFittingPriority: .required,
                                                                     verticalFittingPriority: .defaultLow).height
        
        scrollView.isScrollEnabled = height > scrollView.frame.size.height
    }

}

extension GenericSceneViewController {
    class func create(with genericScene: GenericCardDisplayModel) -> GenericSceneViewController {
        let vc = GenericSceneViewController()
        vc.sceneData = genericScene
        
        return vc
    }
}
