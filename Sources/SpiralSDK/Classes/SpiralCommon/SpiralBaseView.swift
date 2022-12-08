//
//  BaseView.swift
//
//  Created by Martin Vasilev on 4.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import UIKit

/// Custom abstract `UIView` used for loading custom `xib`s.
public class SpiralBaseView: UIView {
    
    /// Should be used to access the actual visible view.
    var contentView: UIView?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
        contentView?.prepareForInterfaceBuilder()
    }
    
    /// Layout Configuration Point
    func setupLayout() {
    }
    
    // MARK: - Private
    
    /// Autoresizes the view to constrain the content view loaded from the interface builder
    private func setupView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        setupLayout()
    }
    
    /// Finds the view (It should be named the same as the class!) and returns it to be set as content view
    ///
    /// - Returns: The actual visible view in the interface builder
    private func loadViewFromNib() -> UIView? {
        guard let bundle = Bundle.spiralResourcesBundle else { return nil }
        
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
