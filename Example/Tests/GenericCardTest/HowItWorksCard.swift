//
//  HowItWorksCard.swift
//  SpiralSDK_Tests
//
//  Created by Ron Soffer on 12/13/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

import SpiralSDK
import SwiftUI

// swiftlint:disable all
struct HowItWorksCard: GenericCardTestModelProtocol {
    
    var cardModel: GenericCardModel? {
        let title = SpiralGenericCardTextComponent(html: "<span style=\"font-family: SFProRounded-Regular; font-size:22px; line-height: 22px; color:black;\">Introducing Social Impact<br />Rewards</span>",
                                             alignment: .center)
        let titleComponent = SpiralGenericCardComponent(type: .text,
                                                  padding: SpiralGenericCardContentPadding(left: 20, right: 20, top: 46, bottom: 0),
                                                  content: title)
        
        let titleImage = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1670959825/sdkClients/SDK_Card_howitworks.png",
                                              fixedHeight: 98)
        let titleImageComponent = SpiralGenericCardComponent(type: .image,
                                                       padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 20, bottom: 0),
                                                       content: titleImage)
        
        let text = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-SemiBold; font-size:18px; line-height: 22px; color:black;\">Impact Rewards<span><br /><span style=\"font-family: SFProRounded-Regular; font-size:15px; line-height: 22px; color:black;\">Now, certain purchases made with your debit card create a social or environmental impact. When you make everyday purchases like buying gas or paying bills, we make a donation to a nonprofit to achieve a related impact.</span><br /><br /><span style=\"font-family: SFProRounded-SemiBold; font-size:18px; line-height: 22px; color:black;\">How it works</span><br /><span style=\"font-family: SFProRounded-Regular; font-size:15px; line-height: 22px; color:black;\">We donate to four trusted, effective nonprofits. We’ve estimated how much these nonprofits spend to achieve a tangible impact — such as planting a tree or delivering a meal — and make a donation in that amount for each swipe.  The social impact totals you see are reflective of your impact all-time, and do not reset every year.</span>
                                                """
        )
        let textComponent = SpiralGenericCardComponent(type: .text,
                                                 padding: SpiralGenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 20),
                                                 content: text)
        
        // Tree
        
        let treeImage = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1649262045/generic-card-images/sr-tree.png",
                                                  fixedWidth: 50,
                                                  fixedHeight: 50,
                                                  contentMode: .aspectFit)
        let treeImageComponent = SpiralGenericCardComponent(type: .image,
                                                      padding: SpiralGenericCardContentPadding(left: 10, right: 18, top: 0, bottom: 0),
                                                      content: treeImage)
        
        let treeImageContainer = SpiralGenericCardComponentContainer(children: [treeImageComponent])
        let treeImageContainerComponent = SpiralGenericCardComponent(type: .container,
                                                               fixedWidth: 78,
                                                               content: treeImageContainer)
        
        let treeText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-SemiBold; font-size:15px; line-height: 22px; color:black;\">Category 1: </span><span style=\"font-family: SFProRounded-Regular; font-size:15px; line-height: 22px; color:black;\">When you pay your electric or gas bill, or buy gas from the gas station, we donate to Eden Reforestation Projects</span>
                                                """
        )
        let treeTextComponent = SpiralGenericCardComponent(type: .text,
                                                 padding: SpiralGenericCardContentPadding(left: 0, right: 10, top: 0, bottom: 0),
                                                 content: treeText)
        
        let treeContainer = SpiralGenericCardComponentContainer(axis: .horizontal, children: [treeImageContainerComponent, treeTextComponent])
        let treeComponent = SpiralGenericCardComponent(type: .container, padding: SpiralGenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 0), content: treeContainer)
        
        
        let whyText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-SemiBold; font-size:18px; line-height: 22px; color:black;\">Why these nonprofits?<span><br /><span style=\"font-family: SFProRounded-Regular; font-size:15px; line-height: 22px; color:black;\">We carefully selected these nonprofits based on their evidence-based results and high quality reputations. If you have questions, please email <a href=\"mailto:nonprofits@spiral.us\">nonprofits@spiral.us</a>.</span>
                                                """
        )
        let whyTextComponent = SpiralGenericCardComponent(type: .text,
                                                 padding: SpiralGenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 20),
                                                 content: whyText)
        
        let moreInfoText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Regular; font-size:16px; line-height: 20px; color:black;\"><a href=\"http://spiral.us\">I want more info</a></span>
                                                """,
                                                          alignment: .center
        )
        let moreInfoComponent = SpiralGenericCardComponent(type: .text,
                                                 padding: SpiralGenericCardContentPadding(left: 32, right: 32, top: 0, bottom: 20),
                                                 content: moreInfoText)
        
        
        
        let contentCover = SpiralGenericCardZComponentContainer(children: [])
        let contentCoverComponent = SpiralGenericCardComponent(type: .zContainer,
//                                                         backgroundColor: "#ffffff",
//                                                         alpha: 0.95,
                                                         blur: true,
                                                         fixedHeight: 75,
                                                         snapToEdges: [.left, .bottom, .right],
                                                         content: contentCover)
        
        let button = SpiralGenericCardButtonComponent(text: "Got it, thanks", textColor: "#000000", borderColor: "#000000", fixedWidth: 200)
        let buttonComponent = SpiralGenericCardComponent(type: .button,
                                                   padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 25),
                                                   snapToEdges: [.left, .bottom, .right],
                                                   link: "dismiss",
                                                   content: button)
        
        let verticalContainer = SpiralGenericCardComponent(type: .container,
                                                     padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 75),
                                                     content: SpiralGenericCardComponentContainer(children:
                                                                                              [titleComponent,
                                                                                               titleImageComponent,
                                                                                               textComponent,
                                                                                               treeComponent,
                                                                                               whyTextComponent,
                                                                                               moreInfoComponent
                                                                                              ]))
        let scrollContainer = SpiralGenericCardComponent(type: .scrollContainer,
                                                   content: SpiralGenericCardScrollComponentContainer(children: [verticalContainer]))
        
        let zContainer = SpiralGenericCardComponent(type: .zContainer,
                                              content: SpiralGenericCardZComponentContainer(children: [scrollContainer, contentCoverComponent, buttonComponent]))
        
        return GenericCardModel(root: SpiralGenericCardComponent(type: .modal,
                                                           content: SpiralGenericCardComponentContainer(children:
                                                                                                    [
                                                                                                        zContainer
                                                                                                    ])))
    }
    
}
