//
//  UIColor+AssetCatalogColors.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 6.05.20.
//  Copyright © 2020 Upnetix. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {

    static let cardShadowNew = color("cardShadowNew")
    static let completeBlack = color("black")
    static let completeWhite = color("white")
    static let blueyGrey = color("blueyGrey")
    static let bluishGrey = color("bluishGrey")
    static let brownishGrey = color("brownishGrey")
    static let charcoalGrey = color("charcoalGrey")
    static let charcoalGrey2 = color("charcoalGreyTwo")
    static let darkMintGreen = color("darkMintGreen")
    static let darkPink = color("darkPink")
    static let darkPinkWith05Opacity = color("darkPink0.05")
    static let darkSeaGreen = color("darkSeaGreen")
    static let darkTurquoise = color("darkTurquoise")
    static let lightBlueGrey = color("lightBlueGrey")
    static let lightBlueGrey50Opacity = color("lightBlueGrey0.5")
    static let slateGrey = color("slateGrey")
    static let mintGreen = color("mintGreen")
    static let datepickerGrey = color("datepickerGrey")
    static let negativeRed = color("negativeRed")
    static let darkBlueGrey = color("darkBlueGrey")
    static let greenyBlue = color("greenyBlue")
    static let disabledButton = color("disabledButton")
    static let inactiveButton = color("inactiveButton")
    static let aquaMarine = color("aquaMarine")
    static let lightGreyBlue = color("lightGreyBlue")
    static let lightGreyBlueWith30Opacity = color("lightGreyBlue0.3")
    static let paleGrey = color("paleGrey")
    static let battleshipGrey = color("battleshipGrey")
    static let battleshipGrey02Opacity = color("battleshipGrey0.2")
    static let lightBlue = color("lightBlue")
    static let spiralLightGrey = color("spiralLightGrey")
    static let goalNotAchievedGrey = color("goalNotAchievedGrey")
    static let niceBlue = color("niceBlue")
    static let charcoalGreyTwo = color("charcoalGreyTwo")
    static let veryLightPink = color("veryLightPink")
    static let toolbarVeryLightPink = color("toolbarVeryLightPink")
    static let paleBlue = color("paleBlue")
    static let paleBlueTwo = color("paleBlueTwo")
    static let black05Opacity = color("black05Opacity")
    static let steel = color("steel")
    static let offSwitchGrey = color("offSwitchGrey")
    static let silver = color("silver")
    static let paleLilac = color("paleLilac")
    static let cloudyBlue = color("cloudyBlue")
    static let searchBarGrey = color("searchBarGrey")
    static let textGrey = color("textGrey")
    static let enhancedLightGrey = color("enhancedLightGrey")
    static let dullOrange = color("dullOrange")
    static let softBlue = color("softBlue")
    static let darkishPink = color("darkishPink")
    static let lavender = color("lavender")
    static let lightGrey50Opacity = color("lightGrey0.5")
    static let moveMoneyTabBorderGrey = color("MoveMoneyTabGrey")
    static let moveMoneyTabFillGrey = color("moveMoneyTabFillGrey")
    static let moveMoneyTabFillLightGreen = color("tabLightGreen")
    static let moveMoneyTabFillGreen = color("tabGreen")
    static let lightOrange = color("lightOrange")
    static let azureishWhite = color("azureishWhite")

    static func color(_ colorName: String) -> UIColor {
        return UIColor(named: colorName) ?? UIColor()
    }

    static func color(_ colorName: String?) -> UIColor? {
        guard let colorName = colorName else { return nil }
        return color(colorName)
    }

}
