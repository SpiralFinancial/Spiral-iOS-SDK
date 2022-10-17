//
//  GenericCardDisplayHandler.swift
//  SpiralBank
//
//  Created by Ron Soffer on 10/20/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

protocol GenericCardDisplayHandler: AnyObject {
    
    func handleCellLayoutUpdate(constraintUpdater: @escaping () -> Void)
    
}
