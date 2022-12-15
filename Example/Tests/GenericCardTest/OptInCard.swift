//
//  OptInCard.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 12/14/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

import SpiralSDK

// swiftlint:disable all
struct OptInCard: GenericCardTestModelProtocol {
    
    var cardModel: GenericCardModel? {
        
        let image = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1671046939/sdkClients/Piggybank-icon.png",
                                              fixedHeight: 60)
        let imageComponent = SpiralGenericCardComponent(type: .image,
                                                        padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 20, bottom: 20), content: image)
        
        let title = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Regular; font-size:22px; line-height: 28px; color:black;\">Introducing Social Impact Rewards</span>
                                                """,
                                                   alignment: .center
        )
        let titleComponent = SpiralGenericCardComponent(type: .text,
                                                 padding: SpiralGenericCardContentPadding(left: 18, right: 18, top: 0, bottom: 10),
                                                 content: title)
        
        let description = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Regular; font-size:16px; line-height: 24px; color:black;\">When you make certain purchases with your debit card, your transaction amount will be rounded up and the money will be used as a charitable contribution.</span>
                                                """,
                                                   alignment: .center
        )
        let descriptionComponent = SpiralGenericCardComponent(type: .text,
                                                 padding: SpiralGenericCardContentPadding(left: 16, right: 16, top: 0, bottom: 10),
                                                 content: description)
        
        let howItWorksButton = SpiralGenericCardButtonComponent(text: "How does this work?", textColor: "#D73275", borderColor: "ffffff", fixedWidth: 200)
        let howItWorksButtonComponent = SpiralGenericCardComponent(type: .button,
                                                   padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 10),
                                                   link: "/actions/showModal?type=HOW_IT_WORKS",
                                                   content: howItWorksButton)
        
        let button = SpiralGenericCardButtonComponent(text: "Set up Instant Impact", textColor: "#ffffff", borderColor: "#D73275")
        let buttonComponent = SpiralGenericCardComponent(type: .button,
                                                         backgroundColor: "#D73275",
                                                   padding: SpiralGenericCardContentPadding(left: 16, right: 16, top: 0, bottom: 25),
                                                   link: "/flow?type=customerSettings",
                                                   content: button)
        
        return GenericCardModel(root: SpiralGenericCardComponent(type: .container,
                                                           content: SpiralGenericCardComponentContainer(children:
                                                                                                    [imageComponent,
                                                                                                     titleComponent,
                                                                                                     descriptionComponent,
                                                                                                     howItWorksButtonComponent,
                                                                                                     buttonComponent
                                                                                                    ])))
    }
    
}
