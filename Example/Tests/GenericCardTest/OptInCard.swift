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
        
        let imageBg = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1692986460/sdk/img/forest_bg_mobile.png",
                                                      contentMode: .aspectFill)
        let imageBgComponent = SpiralGenericCardComponent(type: .image,
                                                          padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 0),
                                                          content: imageBg)
        
        let notification = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1692986744/sdk/img/Notification3_shelter.png")
        let notificationComponent = SpiralGenericCardComponent(type: .image,
                                                               fixedHeight: 72,
                                                        padding: SpiralGenericCardContentPadding(left: 10, right: 10, top: 27, bottom: 24), content: notification)
        
        let title = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Bold; font-size:18px; line-height: 28px; color:white;\">BE AN EVERYDAY HERO<br />WITH EVERYDAY PURCHASES</span>
                                                """,
                                                   alignment: .center
        )
        let titleComponent = SpiralGenericCardComponent(type: .text,
                                                 padding: SpiralGenericCardContentPadding(left: 18, right: 18, top: 0, bottom: 15),
                                                 content: title)
        
        let description = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Regular; font-size:15px; line-height: 24px; color:white;\">Support charities and communities you care about by rounding up card purchases you already make. Adjust anytime.</span>
                                                """,
                                                   alignment: .center
        )
        let descriptionComponent = SpiralGenericCardComponent(type: .text,
                                                 padding: SpiralGenericCardContentPadding(left: 16, right: 16, top: 0, bottom: 25),
                                                 content: description)
        
        let button = SpiralGenericCardButtonComponent(text: "Select My Impact", textColor: "#ffffff", textSize: 16, borderColor: "#D73275")
        let buttonComponent = SpiralGenericCardComponent(type: .button,
                                                         backgroundColor: "#D73275",
                                                         fixedHeight: 50,
                                                   padding: SpiralGenericCardContentPadding(left: 16, right: 16, top: 0, bottom: 30),
                                                   link: "/flow?type=customerSettings",
                                                   content: button)
        
        let containerComponent = SpiralGenericCardComponent(type: .container,
                                                   content: SpiralGenericCardComponentContainer(children:
                                                                                            [notificationComponent,
                                                                                             titleComponent,
                                                                                             descriptionComponent,
                                                                                             buttonComponent
                                                                                            ]))
        
        return GenericCardModel(root: SpiralGenericCardComponent(type: .zContainer,
                                                           content: SpiralGenericCardZComponentContainer(children:
                                                                                                    [
                                                                                                        imageBgComponent,
                                                                                                        containerComponent
                                                                                                    ])))
    }
    
}
