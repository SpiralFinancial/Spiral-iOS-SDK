//
//  SpiralWhiteNavigationController.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 27.07.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit

class SpiralWhiteNavigationController: UINavigationController {
    
    init() {
        super.init(navigationBarClass: PassThroughNavigationBar.self, toolbarClass: nil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: PassThroughNavigationBar.self, toolbarClass: nil)
        viewControllers = [rootViewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance(titleAttributes: titleTextAttributes(),
                        tintColor: .black)
    }
    
    private func titleTextAttributes(textColor: UIColor = .black) -> [NSAttributedString.Key: Any] {
        return  [.foregroundColor: textColor,
                 .font: AppFont.semibold(size: 17)]
    }
    
    private func setupAppearance(titleAttributes: [NSAttributedString.Key: Any],
                                 tintColor: UIColor) {
        navigationBar.barTintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.tintColor = tintColor
        navigationBar.titleTextAttributes = titleAttributes
        navigationBar.largeTitleTextAttributes = titleAttributes
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = titleAttributes
            appearance.largeTitleTextAttributes = titleAttributes
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }

        navigationBar.accessibilityIdentifier = "topNavBarView"
        setNavigationBorderColor(to: .white)
    }
    
    private func setupTranslucentAppearance(titleAttributes: [NSAttributedString.Key: Any],
                                            tintColor: UIColor) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = tintColor
        navigationBar.isTranslucent = true
        navigationBar.titleTextAttributes = titleAttributes
        navigationBar.largeTitleTextAttributes = titleAttributes
                
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            appearance.titleTextAttributes = titleAttributes
            appearance.largeTitleTextAttributes = titleAttributes
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
    }
    
    func setAppearance(translucent: Bool, titleTextColor: UIColor) {
        if translucent {
            setupTranslucentAppearance(titleAttributes: titleTextAttributes(textColor: titleTextColor),
                                       tintColor: titleTextColor)
            
            (navigationBar as? PassThroughNavigationBar)?.isPassThroughEnabled = true
        } else {
            setupAppearance(titleAttributes: titleTextAttributes(textColor: titleTextColor),
                            tintColor: .black)
            
            (navigationBar as? PassThroughNavigationBar)?.isPassThroughEnabled = false
        }
    }
    
    func setNavigationBorderColor(to color: UIColor) {
        let shadowImage = UIImage.imageWithColor(color: color)
        
        navigationBar.shadowImage = shadowImage
        if #available(iOS 13.0, *) {
            navigationBar.standardAppearance.shadowImage = shadowImage
            navigationBar.scrollEdgeAppearance?.shadowImage = shadowImage
        }
    }
}

/// Passes through all touch events to views behind it, except when the
/// touch occurs in a contained UIControl or view with a gesture
/// recognizer attached
final class PassThroughNavigationBar: UINavigationBar {
    
    var isPassThroughEnabled: Bool = false
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard isPassThroughEnabled else { return super.point(inside: point, with: event) }
        
        guard nestedInteractiveViews(in: self, contain: point) else { return false }
        return super.point(inside: point, with: event)
    }

    private func nestedInteractiveViews(in view: UIView, contain point: CGPoint) -> Bool {

        if view.isPotentiallyInteractive, view.bounds.contains(convert(point, to: view)) {
            return true
        }

        for subview in view.subviews {
            if nestedInteractiveViews(in: subview, contain: point) {
                return true
            }
        }

        return false
    }
}

fileprivate extension UIView {
    var isPotentiallyInteractive: Bool {
        guard isUserInteractionEnabled else { return false }
        return (isControl || doesContainGestureRecognizer)
    }

    var isControl: Bool {
        return self is UIControl
    }

    var doesContainGestureRecognizer: Bool {
        return !(gestureRecognizers?.isEmpty ?? true)
    }
}
