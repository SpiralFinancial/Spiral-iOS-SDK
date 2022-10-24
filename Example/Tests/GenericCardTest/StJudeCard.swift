//
//  StJudeCard.swift
//  SpiralBank
//
//  Created by Aleksandar Gyuzelov on 7.11.21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation
import SpiralSDK

// swiftlint:disable all
struct StJudeCard: GenericCardTestModelProtocol {
    
    var cardModel: GenericCardModel? {
        
        let image = GenericCardImageComponent(url: "https://cdn.zeplin.io/5e3b1c818f31c4b3e2064abd/assets/D14203EE-A7F1-48F3-9136-6E254779F1BA.png",
                                              fixedHeight: 184)
        let imageComponent = GenericCardComponent(type: .image, content: image)
        
        let text = GenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-regular; font-size:16px; line-height: 22px; color:black;\">Danny, Your donation helped four amazing kids got much-needed cancer surgery, thanks for being amazing!</span>
                                                """
        )
        let textComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 16, right: 16, top: 15, bottom: 20),
                                                 content: text)
        
        let button = GenericCardButtonComponent(text: "Ok, got it", textColor: "#D73275", borderColor: "#D73275", fixedWidth: 200)
        let buttonComponent = GenericCardComponent(type: .button,
                                                   padding: GenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 25),
                                                   link: "/home/hideCard?id=1&option=test&type=test",
                                                   content: button)
        
        return GenericCardModel(root: GenericCardComponent(type: .container,
                                                           content: GenericCardComponentContainer(children:
                                                                                                    [imageComponent,
                                                                                                     textComponent,
                                                                                                     buttonComponent
                                                                                                    ])))
    }
    
}
