//
//  UIGestureRecognizer+Closure.swift
//  SpiralBank
//
//  Created by Ron Soffer on 4/20/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

final class BindableTapGestureRecognizer: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}

public typealias EmptyOptionalClosure = (() -> Void)?
