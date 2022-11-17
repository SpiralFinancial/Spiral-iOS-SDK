//
//  ImpactSummaryCard.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 11/8/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SpiralSDK

// swiftlint:disable all
struct ImpactSummaryCard: GenericCardTestModelProtocol {
    
    var cardModel: GenericCardModel? {
        
        
        let headerImage = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1649955512/socially-responsible-rewards/socially-responsible.png",
                                                          fixedWidth: 40,
                                                          fixedHeight: 40)
        let headerImageComponent = SpiralGenericCardComponent(type: .image,
                                                              padding: SpiralGenericCardContentPadding(left: 15, right: 0, top: 12, bottom: 0),
                                                              snapToEdges: [.top, .left],
                                                              content: headerImage)
        
        let headerText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Light; font-size:17px; line-height: 22px; color:white;\">Your Social Impact</span>
                                                """
        )
        let headerTextComponent = SpiralGenericCardComponent(type: .text,
                                                             padding: SpiralGenericCardContentPadding(left: 70, right: 20, top: 12, bottom: 0),
                                                             snapToEdges: [.top, .left, .right],
                                                             content: headerText)
        
        let headerSubtitleText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Light; font-size:14px; line-height: 18px; color:white;\">From swiping your Spiral debit card</span>
                                                """
        )
        let headerSubtitleTextComponent = SpiralGenericCardComponent(type: .text,
                                                             padding: SpiralGenericCardContentPadding(left: 70, right: 20, top: 36, bottom: 0),
                                                                     snapToEdges: [.top, .left, .right],
                                                             content: headerSubtitleText)
        
        
        let header = SpiralGenericCardZComponentContainer(children: [headerImageComponent, headerTextComponent, headerSubtitleTextComponent])
        let headerComponent = SpiralGenericCardComponent(type: .zContainer,
                                                         backgroundGradient: SpiralGenericCardGradient(direction: .leftToRight, colors: ["#a9b9f2", "#d55289"], distribution: [0, 0.8]),
                                                         fixedHeight: 65,
                                                         padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 10),
                                                         content: header)
        
        
        let categoryImage = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1649955512/socially-responsible-rewards/tree.png",
                                                            fixedWidth: 40,
                                                            fixedHeight: 40)
        let categoryImageComponent = SpiralGenericCardComponent(type: .image,
                                                                padding: SpiralGenericCardContentPadding(left: 15, right: 0, top: 12, bottom: 0),
                                                                snapToEdges: [.left, .top],
                                                                content: categoryImage)
        
        let categoryCountText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Light; font-size:36px; line-height: 40px; color:#414d54; text-align:center; dispay:block;\">12</span>
                                                """,
                                                               alignment: .center
        )
        let categoryCountComponent = SpiralGenericCardComponent(type: .text,
                                                                fixedWidth: 81,
                                                                padding: SpiralGenericCardContentPadding(left: 65, right: 0, top: 11, bottom: 0),
                                                                snapToEdges: [.top, .left],
                                                                content: categoryCountText)
        
        let categoryDescriptionText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Medium; font-size:14px; line-height: 17px; color:black;\">Trees planted</span><br />
                                                <span style=\"font-family: SFProRounded-Regular; font-size:14px; line-height: 17px; color:black;\">to help the enviroment</span>
                                                """
        )
        let categoryDescriptionComponent = SpiralGenericCardComponent(type: .text,
                                                                      padding: SpiralGenericCardContentPadding(left: 155, right: 15, top: 15, bottom: 15.5),
                                                                      snapToEdges: [.top, .left, .right, .bottom],
                                                                      content: categoryDescriptionText)
        
        let separator = SpiralGenericCardComponentContainer(children: [])
        let separatorComponent = SpiralGenericCardComponent(type: .container,
                                                            backgroundColor: "#ced4da",
                                                            fixedHeight: 0.5,
                                                            padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 0),
                                                            snapToEdges: [.left, .right, .bottom],
                                                            content: separator)
        
        
        let categoryContainer = SpiralGenericCardZComponentContainer(children: [categoryImageComponent, categoryCountComponent, categoryDescriptionComponent, separatorComponent])
        let categoryContainerComponent = SpiralGenericCardComponent(type: .zContainer,
                                                                    content: categoryContainer)
        
        let button = SpiralGenericCardButtonComponent(text: "Remind me how this works", textColor: "#d83275", textSize: 14, textWeight: .medium, borderColor: "#ffffff")
        let buttonComponent = SpiralGenericCardComponent(type: .button,
                                                   padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 21, bottom: 27),
                                                   link: "/webview?url=https://spiral.us",
                                                   content: button)
        
        return GenericCardModel(root: SpiralGenericCardComponent(type: .container,
                                                           content: SpiralGenericCardComponentContainer(children:
                                                                                                    [headerComponent,
                                                                                                     categoryContainerComponent,
                                                                                                     buttonComponent
                                                                                                    ])))
    }
    
}
