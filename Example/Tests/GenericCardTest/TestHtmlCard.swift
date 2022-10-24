//
//  TestHtmlCard.swift
//  SpiralBank
//
//  Created by Ron Soffer on 5/4/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import SpiralSDK

// swiftlint:disable all
struct TestHtmlCard: GenericCardTestModelProtocol {
    
    var cardModel: GenericCardModel? {
        
        let image = GenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/app/cards/ChristmasRedDecor.png",
                                              fixedHeight: 230,
                                              contentMode: .aspectFill)
        let imageComponent = GenericCardComponent(type: .image,
                                                  padding: GenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 16),
                                                  content: image)
        
        let title = GenericCardTextComponent(html: """
                                                    <span style=\"font-family: sfpro-regular; font-size:22px; line-height: 28px; color:black;\">Happy Holidays,</span>
                                                    """,
                                             alignment: .center)
        let titleComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 32, right: 32, top: 0, bottom: 5),
                                                 content: title)
        let nameTitle = GenericCardTextComponent(html: """
                                                    <span style=\"font-family: sfpro-regular; font-size:22px; line-height: 28px; color:black;\">Deckel ✨</span>
                                                    """,
                                                 alignment: .center)
        let nameTitleComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 32, right: 32, top: 0, bottom: 16),
                                                 content: nameTitle)
        
        let text = GenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-regular; font-size:16px; line-height: 23px; color:charcoalGrey;\">Having you as our customer is the best holiday gift we could ever wish for.</span>
                                                """,
                                            alignment: .center)
        let textComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 16, right: 16, top: 0, bottom: 20),
                                                 content: text)
        
        let text1 = GenericCardHtmlComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-regular; font-size:16px; line-height: 22px; text-align: center; display: block;\">We hope that you have an amazing holiday season, and wish you a very happy new year.</span>
                                                """)
        let text1Component = GenericCardComponent(type: .html,
                                                  padding: GenericCardContentPadding(left: 16, right: 16, top: 0, bottom: 16),
                                                  content: text1)
        
        let button = GenericCardButtonComponent(text: "Thank you ❤️",
                                                textColor: "#D73275",
                                                textSize: 14,
                                                borderColor: "#D73275",
                                                fixedWidth: 121,
                                                fixedHeight: 39)
        let buttonComponent = GenericCardComponent(type: .button,
                                                   padding: GenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 20),
                                                   link: "/actions/showModal?id=45",
                                                   content: button)
        
        return GenericCardModel(root: GenericCardComponent(type: .container,
                                                           content: GenericCardComponentContainer(children:
                                                                                                    [imageComponent,
                                                                                                     titleComponent,
                                                                                                     nameTitleComponent,
                                                                                                     textComponent,
                                                                                                     text1Component,
                                                                                                     buttonComponent
                                                                                                    ])))
    }
}
