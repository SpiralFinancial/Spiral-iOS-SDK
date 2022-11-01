//
//  GenericCardTableViewCell.swift
//  SpiralBank
//
//  Created by Ron Soffer on 7/26/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

public typealias GenericCardConfigurator = SpiralBaseViewConfigurator<GenericCardTableViewCell>

public class GenericCardTableViewCell: UITableViewCell, Configurable {

    // MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .clear
            containerView.layer.cornerRadius = Constants.Styles.Corners.homeSceneCellRadius
            containerView.layer.apply(shadow: Constants.Styles.Shadow.homeSceneCellShadow)
            containerView.layer.apply(border: Constants.Styles.Border.homeSceneCellBorder)
        }
    }
    
    @IBOutlet private weak var genericCardView: GenericCardView! {
        didSet {
            genericCardView.layer.masksToBounds = true
            genericCardView.layer.cornerRadius = Constants.Styles.Corners.homeSceneCellRadius
            genericCardView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner,
                .layerMinXMaxYCorner
            ]
        }
    }

    // MARK: - Configurable
    public func configureWith(_ data: GenericCardDisplayModel) {
        genericCardView.configureWith(data)
    }
}
