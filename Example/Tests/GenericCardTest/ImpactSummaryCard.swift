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
                                                <span style=\"font-family: SFProRounded-Light; font-size:17px; line-height: 22px; color:white;\">Your Social Impact is <b>OFF</b></span>
                                                """
        )
        let headerTextComponent = SpiralGenericCardComponent(type: .text,
                                                             padding: SpiralGenericCardContentPadding(left: 70, right: 20, top: 12, bottom: 0),
                                                             snapToEdges: [.top, .left, .right],
                                                             content: headerText)
        
        let headerSubtitleText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Light; font-size:14px; line-height: 18px; color:white;\">Contributions from swiping your debit card</span>
                                                """
        )
        let headerSubtitleTextComponent = SpiralGenericCardComponent(type: .text,
                                                             padding: SpiralGenericCardContentPadding(left: 70, right: 20, top: 36, bottom: 0),
                                                                     snapToEdges: [.top, .left, .right],
                                                             content: headerSubtitleText)
        
        
        let header = SpiralGenericCardZComponentContainer(children: [headerImageComponent, headerTextComponent, headerSubtitleTextComponent])
        let headerComponent = SpiralGenericCardComponent(type: .zContainer,
//                                                         backgroundGradient: SpiralGenericCardGradient(direction: .leftToRight, colors: ["#a9b9f2", "#d55289"], distribution: [0, 0.8]),
                                                         backgroundColor: "#126BC5",
                                                         fixedHeight: 65,
                                                         padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 10),
                                                         content: header)
        
        let categoryBlueCircleImage = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1679508033/sdk/img/everyday-impact-cirlce.png",
                                                                      fixedWidth: 48,
                                                                      fixedHeight: 48)
        let categoryBlueCircleImageComponent = SpiralGenericCardComponent(type: .image,
                                                                          padding: SpiralGenericCardContentPadding(left: 11, right: 0, top: 8, bottom: 0),
                                                                snapToEdges: [.left, .top],
                                                                content: categoryBlueCircleImage)
        
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
        
        let categoryContainer = SpiralGenericCardZComponentContainer(children: [categoryBlueCircleImageComponent, categoryImageComponent, categoryCountComponent, categoryDescriptionComponent, separatorComponent])
        let categoryContainerComponent = SpiralGenericCardComponent(type: .zContainer,
                                                                    content: categoryContainer)
        
        // =======================================================
        let nonProfitImage = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1693343630/socially-responsible-rewards/money.png",
                                                            fixedWidth: 40,
                                                            fixedHeight: 40)
        let nonProfitImageComponent = SpiralGenericCardComponent(type: .image,
                                                                padding: SpiralGenericCardContentPadding(left: 15, right: 0, top: 12, bottom: 0),
                                                                snapToEdges: [.left, .top],
                                                                content: nonProfitImage)
        
        let nonProfitAmountText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Light; font-size:32px; line-height: 40px; color:#414d54; text-align:center; dispay:block;\">$0.99</span>
                                                """,
                                                               alignment: .center
        )
        let nonProfitAmountComponent = SpiralGenericCardComponent(type: .text,
                                                                padding: SpiralGenericCardContentPadding(left: 67, right: 0, top: 11, bottom: 0),
                                                                snapToEdges: [.top, .left],
                                                                content: nonProfitAmountText)
        
        let nonProfitPlusImage = SpiralGenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1638470017/app/icons/plus-circle.svg",
                                                            fixedWidth: 40,
                                                            fixedHeight: 40)
        let nonProfitPlusImageComponent = SpiralGenericCardComponent(type: .image,
                                                                padding: SpiralGenericCardContentPadding(left: 0, right: 10, top: 18, bottom: 0),
                                                                snapToEdges: [.right, .top],
                                                                link: "/flow?type=customerSettings",
                                                                content: nonProfitPlusImage)
        
        let nonProfitDescriptionText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Regular; font-size:14px; line-height: 17px; color:black;\">Round up<br />to support</span>
                                                """
        )
        let nonProfitDescriptionComponent = SpiralGenericCardComponent(type: .text,
                                                                      padding: SpiralGenericCardContentPadding(left: 0, right: 80, top: 14, bottom: 0),
                                                                      snapToEdges: [.top, .right],
                                                                      content: nonProfitDescriptionText)
        
        let nonProfitNameText = SpiralGenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: SFProRounded-Light; font-size:24px; line-height: 30px; text-align: center; color:black;\">Zero Footprint</span>
                                                """,
                                                               alignment: .center
        )
        let nonProfitNameComponent = SpiralGenericCardComponent(type: .text,
                                                                      padding: SpiralGenericCardContentPadding(left: 10, right: 10, top: 65, bottom: 15),
                                                                snapToEdges: [.top, .left, .bottom, .right],
                                                                      content: nonProfitNameText)
        
        let nonProfitContainer = SpiralGenericCardZComponentContainer(children: [nonProfitImageComponent, nonProfitAmountComponent, nonProfitPlusImageComponent, nonProfitDescriptionComponent, nonProfitNameComponent])
        let nonProfitContainerComponent = SpiralGenericCardComponent(type: .zContainer,
                                                                    content: nonProfitContainer)
        
        // =======================================================
        
        
        
        let categoriesContainer = SpiralGenericCardComponentContainer(children: [categoryContainerComponent, nonProfitContainerComponent])
        let categoriesContainerComponent = SpiralGenericCardComponent(type: .container,
                                                                    content: categoriesContainer)
        
        let offMask = SpiralGenericCardZComponentContainer(children: [])
        let offMaskComponent = SpiralGenericCardComponent(type: .zContainer, backgroundColor: "ffffff", alpha: 0.4, content: offMask)
        
        let categoriesZContainer = SpiralGenericCardZComponentContainer(children: [categoriesContainerComponent, offMaskComponent])
        let categoriesZContainerComponent = SpiralGenericCardComponent(type: .zContainer,
                                                                    content: categoriesZContainer)
        
        let button = SpiralGenericCardButtonComponent(text: "How does this work?", textColor: "#126BC5", textSize: 14, textWeight: .medium, borderColor: "#ffffff")
        let buttonComponent = SpiralGenericCardComponent(type: .button,
                                                   padding: SpiralGenericCardContentPadding(left: 0, right: 0, top: 21, bottom: 18),
                                                   link: "/webview?url=https://spiral.us",
                                                   content: button)
        
        let editButton = SpiralGenericCardButtonComponent(text: "Instant Impact Settings", textColor: "#000000", textSize: 14, textWeight: .medium, borderColor: "#000000")
        let editButtonComponent = SpiralGenericCardComponent(type: .button,
                                                   padding: SpiralGenericCardContentPadding(left: 40, right: 40, top: 0, bottom: 27),
                                                   link: "/flow?type=customerSettings",
                                                   content: editButton)
        
        let turnOnButton = SpiralGenericCardButtonComponent(text: "Turn on instant impact", textColor: "#ffffff", textSize: 14, textWeight: .medium, borderColor: "#126BC5")
        let turnOnButtonComponent = SpiralGenericCardComponent(type: .button,
                                                               backgroundColor: "#126BC5",
                                                               padding: SpiralGenericCardContentPadding(left: 40, right: 40, top: 0, bottom: 27),
                                                               link: "/flow?type=customerSettings",
                                                               content: turnOnButton)
        
        return GenericCardModel(root: SpiralGenericCardComponent(type: .container,
                                                           content: SpiralGenericCardComponentContainer(children:
                                                                                                    [headerComponent,
                                                                                                     categoriesZContainerComponent,
                                                                                                     buttonComponent,
                                                                                                     editButtonComponent,
                                                                                                     turnOnButtonComponent
                                                                                                    ])))
    }
    
}
