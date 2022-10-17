//
//  GenericCardImageView.swift
//  SpiralBank
//
//  Created by Ron Soffer on 7/26/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

class GenericCardImageView: GenericCardComponentView {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    private weak var aspectConstraint: NSLayoutConstraint?
    
    private let imageDownloader: SpiralImageDownloadService = SpiralImageDownloadManager()
    
    deinit {
        // This is intended to reduce SDWebImage concurrency issues
        // when accessing the image view while it is being dealloc'd
        
        let keepAroundImgView: UIImageView = imageView
        
        let delayTime = 5
        
        DispatchQueue
            .main
            .asyncAfter(deadline: DispatchTime.now() + Double(Int64(delayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                        execute: {
                _ = keepAroundImgView.description
            })
    }
    
    override func configureWith(_ data: GenericCardComponentDisplayModel) {
        super.configureWith(data)
        
        guard let imageComponentData = data.componentModel.content as? GenericCardImageComponent else { return }
        
        imageView.image = nil
        imageDownloader.populateImageView(imageView, urlString: imageComponentData.url, placeholderImage: nil)
        
        if let contentMode = imageComponentData.contentMode {
            imageView.contentMode = contentMode.asViewContentMode
        }
        
        if let aspectConstraint = aspectConstraint {
            imageView.removeConstraint(aspectConstraint)
            self.aspectConstraint = nil
        }
        if let aspectRatio = imageComponentData.aspectRatio,
           let ratioVal = aspectRatio.toHeightAspectRatio {
            aspectConstraint = imageView.aspectRatioConstraint(ratioVal)
            aspectConstraint?.isActive = true
        }
    }
    
    override func applyFixedDimensions() {
        
        guard let imageComponentData = componentModel?.content as? GenericCardImageComponent else { return }
        
        if let fixedWidth = imageComponentData.fixedWidth {
            widthConstraint.constant = fixedWidth
            widthConstraint.isActive = true
        } else if let fixedWidth = componentModel?.fixedWidth {
            widthConstraint.constant = fixedWidth
            widthConstraint.isActive = true
        } else {
            widthConstraint.isActive = false
        }

        if let fixedHeight = imageComponentData.fixedHeight {
            heightConstraint.constant = fixedHeight
            heightConstraint.isActive = true
        } else if let fixedHeight = componentModel?.fixedHeight {
            heightConstraint.constant = fixedHeight
            heightConstraint.isActive = true
        } else {
            heightConstraint.isActive = false
        }
        
    }
    
}

extension UIView {

    func aspectRatioConstraint(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
    
}
