//
//  TestModalCard.swift
//  SpiralBank
//
//  Created by Ron Soffer on 3/17/22.
//  Copyright © 2022 Upnetix. All rights reserved.
//

import Foundation
import SpiralSDK

// swiftlint:disable all
struct TestModalCard: GenericCardTestModelProtocol {
    
    var cardModel: GenericCardModel? {
        let title = GenericCardTextComponent(html: "<span style=\"font-family: sfpro-regular; font-size:22px; line-height: 22px; color:black;\">Introducing Social Impact<br />Rewards</span>",
                                             alignment: .center)
        let titleComponent = GenericCardComponent(type: .text,
                                                  padding: GenericCardContentPadding(left: 20, right: 20, top: 46, bottom: 0),
                                                  content: title)
        
        let titleImage = GenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1649263862/generic-card-images/spiral-debitcard-angled.png",
                                              fixedHeight: 98)
        let titleImageComponent = GenericCardComponent(type: .image,
                                                       padding: GenericCardContentPadding(left: 0, right: 0, top: 20, bottom: 0),
                                                       content: titleImage)
        
        let text = GenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-semibold; font-size:18px; line-height: 22px; color:black;\">Impact Rewards<span><br /><span style=\"font-family: sfpro-regular; font-size:15px; line-height: 22px; color:black;\">Now, certain purchases made with your Spiral Visa® debit card create a social or environmental impact. When you make everyday purchases like buying gas or paying bills, we make a donation to a nonprofit to achieve a related impact.</span><br /><br /><span style=\"font-family: sfpro-semibold; font-size:18px; line-height: 22px; color:black;\">How it works</span><br /><span style=\"font-family: sfpro-regular; font-size:15px; line-height: 22px; color:black;\">We donate to four trusted, effective nonprofits. We’ve estimated how much these nonprofits spend to achieve a tangible impact — such as planting a tree or delivering a meal — and make a donation in that amount for each swipe.  The social impact totals you see are reflective of your impact all-time, and do not reset every year.</span>
                                                """
        )
        let textComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 20),
                                                 content: text)
        
        // Tree
        
        let treeImage = GenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1649262045/generic-card-images/sr-tree.png",
                                                  fixedWidth: 50,
                                                  fixedHeight: 50,
                                                  contentMode: .aspectFit)
        let treeImageComponent = GenericCardComponent(type: .image,
                                                      padding: GenericCardContentPadding(left: 10, right: 18, top: 0, bottom: 0),
                                                      content: treeImage)
        
        let treeImageContainer = GenericCardComponentContainer(children: [treeImageComponent])
        let treeImageContainerComponent = GenericCardComponent(type: .container,
                                                               fixedWidth: 78,
                                                               content: treeImageContainer)
        
        let treeText = GenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-semibold; font-size:15px; line-height: 22px; color:black;\">Category 1: </span><span style=\"font-family: sfpro-regular; font-size:15px; line-height: 22px; color:black;\">When you pay your electric or gas bill, or buy gas from the gas station, we donate to Eden Reforestation Projects</span>
                                                """
        )
        let treeTextComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 0, right: 10, top: 0, bottom: 0),
                                                 content: treeText)
        
        let treeContainer = GenericCardComponentContainer(axis: .horizontal, children: [treeImageContainerComponent, treeTextComponent])
        let treeComponent = GenericCardComponent(type: .container, padding: GenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 0), content: treeContainer)
        
        // Restaurant
        
        let restaurantImage = GenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1649262045/generic-card-images/sr-coffee.png",
                                                  fixedWidth: 50,
                                                  fixedHeight: 50,
                                                  contentMode: .aspectFit)
        let restaurantImageComponent = GenericCardComponent(type: .image,
                                                      padding: GenericCardContentPadding(left: 10, right: 18, top: 0, bottom: 0),
                                                      content: restaurantImage)
        
        let restaurantImageContainer = GenericCardComponentContainer(children: [restaurantImageComponent])
        let restaurantImageContainerComponent = GenericCardComponent(type: .container,
                                                               fixedWidth: 78,
                                                               content: restaurantImageContainer)
        
        let restaurantText = GenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-semibold; font-size:15px; line-height: 22px; color:black;\">Category 2: </span><span style=\"font-family: sfpro-regular; font-size:15px; line-height: 22px; color:black;\">When you buy groceries or eat a restaurant, we donate to the World Food Programme</span>
                                                """
        )
        let restaurantTextComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 0, right: 10, top: 0, bottom: 0),
                                                 content: restaurantText)
        
        let restaurantContainer = GenericCardComponentContainer(axis: .horizontal, children: [restaurantImageContainerComponent, restaurantTextComponent])
        let restaurantComponent = GenericCardComponent(type: .container, padding: GenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 0), content: restaurantContainer)
        
        // Water
        
        let waterImage = GenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1649262045/generic-card-images/sr-water.png",
                                                  fixedWidth: 50,
                                                  fixedHeight: 50,
                                                  contentMode: .aspectFit)
        let waterImageComponent = GenericCardComponent(type: .image,
                                                      padding: GenericCardContentPadding(left: 10, right: 18, top: 0, bottom: 0),
                                                      content: waterImage)
        
        let waterImageContainer = GenericCardComponentContainer(children: [waterImageComponent])
        let waterImageContainerComponent = GenericCardComponent(type: .container,
                                                               fixedWidth: 78,
                                                               content: waterImageContainer)
        
        let waterText = GenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-semibold; font-size:15px; line-height: 22px; color:black;\">Category 3: </span><span style=\"font-family: sfpro-regular; font-size:15px; line-height: 22px; color:black;\">When you buy coffee, tea, or juice, we donate to Evidence Action</span>
                                                """
        )
        let waterTextComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 0, right: 10, top: 0, bottom: 0),
                                                 content: waterText)
        
        let waterContainer = GenericCardComponentContainer(axis: .horizontal, children: [waterImageContainerComponent, waterTextComponent])
        let waterComponent = GenericCardComponent(type: .container, padding: GenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 0), content: waterContainer)
        
        
        // Shelter
        
        let shelterImage = GenericCardImageComponent(url: "https://res.cloudinary.com/spiral/image/upload/v1649262045/generic-card-images/sr-roof.png",
                                                  fixedWidth: 50,
                                                  fixedHeight: 50,
                                                  contentMode: .aspectFit)
        let shelterImageComponent = GenericCardComponent(type: .image,
                                                      padding: GenericCardContentPadding(left: 10, right: 18, top: 0, bottom: 0),
                                                      content: shelterImage)
        
        let shelterImageContainer = GenericCardComponentContainer(children: [shelterImageComponent])
        let shelterImageContainerComponent = GenericCardComponent(type: .container,
                                                               fixedWidth: 78,
                                                               content: shelterImageContainer)
        
        let shelterText = GenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-semibold; font-size:15px; line-height: 22px; color:black;\">Category 4: </span><span style=\"font-family: sfpro-regular; font-size:15px; line-height: 22px; color:black;\">When you pay your rent or mortgage, we donate to GiveDirectly</span>
                                                """
        )
        let shelterTextComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 0, right: 10, top: 0, bottom: 0),
                                                 content: shelterText)
        
        let shelterContainer = GenericCardComponentContainer(axis: .horizontal, children: [shelterImageContainerComponent, shelterTextComponent])
        let shelterComponent = GenericCardComponent(type: .container, padding: GenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 0), content: shelterContainer)
        
        
        let whyText = GenericCardTextComponent(html:
                                                """
                                                <span style=\"font-family: sfpro-bold; font-size:18px; line-height: 22px; color:black;\">Why these nonprofits?<span><br /><span style=\"font-family: sfpro-regular; font-size:15px; line-height: 22px; color:black;\">We carefully selected these nonprofits based on their evidence-based results and high quality reputations. If you have questions, please email <a href=\"mailto:nonprofits@spiral.us\">nonprofits@spiral.us</a>.</span>
                                                """
        )
        let whyTextComponent = GenericCardComponent(type: .text,
                                                 padding: GenericCardContentPadding(left: 32, right: 32, top: 20, bottom: 20),
                                                 content: whyText)
        
        
        
        let contentCover = GenericCardZComponentContainer(children: [])
        let contentCoverComponent = GenericCardComponent(type: .zContainer,
//                                                         backgroundColor: "#ffffff",
//                                                         alpha: 0.95,
                                                         blur: true,
                                                         fixedHeight: 75,
                                                         snapToEdges: [.left, .bottom, .right],
                                                         content: contentCover)
        
        let button = GenericCardButtonComponent(text: "Got it, thanks", textColor: "#000000", borderColor: "#000000", fixedWidth: 200)
        let buttonComponent = GenericCardComponent(type: .button,
                                                   padding: GenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 25),
                                                   snapToEdges: [.left, .bottom, .right],
                                                   link: "dismiss",
                                                   content: button)
        
        let verticalContainer = GenericCardComponent(type: .container,
                                                     padding: GenericCardContentPadding(left: 0, right: 0, top: 0, bottom: 75),
                                                     content: GenericCardComponentContainer(children:
                                                                                              [titleComponent,
                                                                                               titleImageComponent,
                                                                                               textComponent,
                                                                                               treeComponent,
                                                                                               restaurantComponent,
                                                                                               waterComponent,
                                                                                               shelterComponent,
                                                                                               whyTextComponent
                                                                                              ]))
        let scrollContainer = GenericCardComponent(type: .scrollContainer,
                                                   content: GenericCardScrollComponentContainer(children: [verticalContainer]))
        
        let zContainer = GenericCardComponent(type: .zContainer,
                                              content: GenericCardZComponentContainer(children: [scrollContainer, contentCoverComponent, buttonComponent]))
        
        return GenericCardModel(root: GenericCardComponent(type: .modal,
                                                           content: GenericCardComponentContainer(children:
                                                                                                    [
                                                                                                        zContainer
                                                                                                    ])))
    }
    
}
