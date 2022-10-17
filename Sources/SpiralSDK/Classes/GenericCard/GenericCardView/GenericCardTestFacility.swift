//
//  GenericCardTestFacility.swift
//  SpiralBank
//
//  Created by Ron Soffer on 8/3/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation
import SwiftUI

protocol GenericCardTestModelProtocol {
    var cardModel: GenericCardModel? { get }
}

enum GenericCardTestModelType: String {
    case xmasCard
    case xmasCardWithModalDeepLink
    case exceededMonthlyLimitCard
    case transferLimitRequestInProgressCard
    case veteransDayCard
    case sameDayMDVerifyCard
    case bottomSheetPresentableCard
    case stJudeCard
    case walimuCard
    case finishSetupCard
    case testCardFromJSON
    case catalogTestCard
    case endOfYearReportCard
    case referFriendCard
    case referMoreFriendsCard
    case referalCelebrationCard
    case MLKCard
    case testModalCard
    case activateDebitMarketing
    case srRewardsIntroPopup
    case fundAccountMarketing
    case testHtmlCard
    case addMoneyCard
    case directDepositCard
    case pinwheelV1Scene
    case pinwheelV2Scene
    case pinwheelV3Scene
    case pinwheelV4Scene
}

// swiftlint:disable all
class GenericCardTestFacility {

    static var shouldDisplayTestCard: Bool {
        #if !DEBUG
            return false
        #endif
        
        if ContainerFactory.isPreviewEnvironment() {
            return true
        }

        return false
    }

    static var testCardToDisplay: GenericCardTestModelType {
        return .veteransDayCard
    }

    static var shouldReadFromJSON: Bool {
        return false
    }
    
    static func genericCardTestModel() -> CardModel? {
        guard let cardPayload = genericCardTestPayloadModel() else { return nil }

        let card = CardModel(payloadType: .generic,
                             payload: cardPayload,
                             colorSchema: .none,
                             header: nil)
        return card
    }
    
    static func genericCardTestPayloadModel() -> GenericCardPayloadModel? {
        guard shouldDisplayTestCard,
              let cardData = getCardModel(for: testCardToDisplay, shouldReadFromJSON: shouldReadFromJSON)
        else { return nil }
        
        return GenericCardPayloadModel(identifier: 1,
                                       type: "test",
                                       data: cardData)
    }

    private static func getCardModel(for type: GenericCardTestModelType, shouldReadFromJSON: Bool = false) -> GenericCardModel? {
#if DEBUG
        if shouldReadFromJSON {
            return readFromJSON(for: type)
        }

        var card: GenericCardTestModelProtocol? = nil
        switch(type) {
        case .veteransDayCard:
            card = VeteransDayCard()
        case .sameDayMDVerifyCard:
            card = SameDayMDVerifyCard()
        case .bottomSheetPresentableCard:
            card = BottomSheetPresentableCard()
        case .stJudeCard:
            card = StJudeCard()
        case .walimuCard:
            card = WalimuCard()
        case .finishSetupCard:
            card = FinishSetupCard()
        case .testCardFromJSON:
            card = TestFromJSONCard()
        case .catalogTestCard:
            card = CatalogTestCard()
        case .transferLimitRequestInProgressCard:
            card = TransferLimitRequestInProgressCard()
        case .exceededMonthlyLimitCard:
            card = ExceededMonthlyLimitCard()
        case .endOfYearReportCard:
            card = EndOfYearReportCard()
        case .referFriendCard:
            card = ReferFriendCard()
        case .referMoreFriendsCard:
            card = ReferMoreFriendsCard()
        case .referalCelebrationCard:
            card = ReferalCelebrationCard()
        case .xmasCard:
            card = XmasCard()
        case .xmasCardWithModalDeepLink:
            card = XmasCardWithModalDeepLink()
        case .MLKCard:
            card = MLKCard()
        case .testModalCard:
            card = TestModalCard()
        case .activateDebitMarketing:
            card = ActivateDebitCardMarketing()
        case .srRewardsIntroPopup:
            card = SocialRewardIntroPopUp()
        case .fundAccountMarketing:
            card = FundAccountMarketing()
        case .testHtmlCard:
            card = TestHtmlCard()
        case .addMoneyCard:
            card = AddMoneyCard()
        case .directDepositCard:
            card = DirectDepositCard()
        case .pinwheelV1Scene:
            card = PinwheelV1Scene()
        case .pinwheelV2Scene:
            card = PinwheelV2Scene()
        case .pinwheelV3Scene:
            card = PinwheelV3Scene()
        case .pinwheelV4Scene:
            card = PinwheelV4Scene()
        }

        if let json = jsonValueForTestCard(model: card?.cardModel) {
            print(json)
        }

        return card?.cardModel
#else
        return nil
#endif
    }

    private static func readFromJSON(for type: GenericCardTestModelType) -> GenericCardModel? {

        guard let resourceURL = Bundle.main.url(forResource: type.rawValue, withExtension: "json"),
              let jsonData = try? Data(contentsOf: resourceURL,
                                       options: .mappedIfSafe)
        else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let genericCard = try decoder.decode(GenericCardModel.self, from: jsonData)
            return genericCard
        } catch {
            print(error)
        }

        return nil
    }

    private static func jsonValueForTestCard(model: GenericCardModel?) -> String? {
        guard let model = model else { return nil }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let jsonData = try encoder.encode(model)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else { return nil }

            return jsonString
        } catch {
            print(error)
        }
        return nil
    }
    
    struct GenericCard_Previews: PreviewProvider {
        static var previews: some View {
            let previewWidth: CGFloat = 400
            
            guard let testPayloadModel = genericCardTestPayloadModel() else { return
                AnyView(Text("Not available")).previewLayout(.fixed(width: previewWidth, height: previewWidth))
            }
            let genericView = GenericCardSwiftUIView(genericCardPayloadModel: testPayloadModel)
            return AnyView(genericView).previewLayout(.fixed(width: previewWidth,
                                                             height: genericView.displayHeight(width: previewWidth)))
        }
    }
    
    struct GenericCardSwiftUIView: UIViewRepresentable {
        let genericCardPayloadModel: GenericCardPayloadModel
        
        var genericCardView: GenericCardView = GenericCardView(frame: .zero)

        private func displayModel() -> GenericCardDisplayModel? {
            let cardConfigurator = GenericCardConfigurator(data: GenericCardDisplayModel(cardData: genericCardPayloadModel,
                                                                         deepLinker: nil,
                                                                         layoutUpdateHandler: { constraintUpdater in
                                                                            }))
            return cardConfigurator.data
        }
        
        func displayHeight(width: CGFloat) -> CGFloat {
            guard let displayModel = displayModel() else { return 0 }
            genericCardView.configureWith(displayModel)
            
            let height = genericCardView.systemLayoutSizeFitting(CGSize(width: width,
                                                                        height: UIView.layoutFittingCompressedSize.height),
                                                                 withHorizontalFittingPriority: .required,
                                                                 verticalFittingPriority: .defaultLow).height
            return height
        }
        
        func makeUIView(context: Context) -> GenericCardView {
                        
            guard let displayModel = displayModel() else { return genericCardView }
            
            genericCardView.configureWith(displayModel)
            return genericCardView
        }

        func updateUIView(_ uiView: GenericCardView, context: Context) {
            guard let displayModel = displayModel() else { return }
            uiView.configureWith(displayModel)
        }
    }
}
