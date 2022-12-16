//
//  GenericCardTestFacility.swift
//  SpiralBank
//
//  Created by Ron Soffer on 8/3/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation
import SwiftUI

import SpiralSDK

protocol GenericCardTestModelProtocol {
    var cardModel: GenericCardModel? { get }
}

enum GenericCardTestModelType: String {
    case stJudeCard
    case testModalCard
    case testHtmlCard
    case impactSummaryCard
    case howItWorksCard
    case optInCard
}

// swiftlint:disable all
class GenericCardTestFacility {

    static var shouldDisplayTestCard: Bool {
        
        if SpiralEnvironment.isPreviewEnvironment() {
            return true
        }

        return true
    }

    static var testCardToDisplay: GenericCardTestModelType {
        return .impactSummaryCard
    }

    static var shouldReadFromJSON: Bool {
        return false
    }
    
    static func genericCardTestModel() -> SpiralCardModel? {
        guard let cardPayload = genericCardTestPayloadModel() else { return nil }

        let card = SpiralCardModel(payloadType: .generic,
                             payload: cardPayload)
        return card
    }
    
    static func genericCardTestPayloadModel() -> SpiralGenericCardPayloadModel? {
        guard shouldDisplayTestCard,
              let cardData = getCardModel(for: testCardToDisplay, shouldReadFromJSON: shouldReadFromJSON)
        else { return nil }
        
        return SpiralGenericCardPayloadModel(identifier: 1,
                                       type: "test",
                                       data: cardData,
                                       isNew: false)
    }

    private static func getCardModel(for type: GenericCardTestModelType, shouldReadFromJSON: Bool = false) -> GenericCardModel? {
        if shouldReadFromJSON {
            return readFromJSON(for: type)
        }

        var card: GenericCardTestModelProtocol? = nil
        switch(type) {
        case .stJudeCard:
            card = StJudeCard()
        case .testModalCard:
            card = TestModalCard()
        case .testHtmlCard:
            card = TestHtmlCard()
        case .impactSummaryCard:
            card = ImpactSummaryCard()
        case .howItWorksCard:
            card = HowItWorksCard()
        case .optInCard:
            card = OptInCard()
        }

        if let json = jsonValueForTestCard(model: card?.cardModel) {
            print(json)
        }

        return card?.cardModel
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
        let genericCardPayloadModel: SpiralGenericCardPayloadModel
        
        var genericCardView: SpiralGenericCardView = SpiralGenericCardView(frame: .zero)

        private func displayModel() -> GenericCardDisplayModel? {
            let cardConfigurator = SpiralGenericCardConfigurator(data: GenericCardDisplayModel(cardData: genericCardPayloadModel,
                                                                         delegate: nil,
                                                                         layoutUpdateHandler: { constraintUpdater in
                                                                            }))
            return cardConfigurator.data
        }
        
        func displayHeight(width: CGFloat) -> CGFloat {
            guard let displayModel = displayModel() else { return 0 }
            genericCardView.configureWith(displayModel)
            
            let height = genericCardView.systemLayoutSizeFitting(CGSize(width: width,
                                                                        height: UILayoutFittingCompressedSize.height),
                                                                 withHorizontalFittingPriority: .required,
                                                                 verticalFittingPriority: .defaultLow).height
            return height
        }
        
        func makeUIView(context: Context) -> SpiralGenericCardView {
                        
            guard let displayModel = displayModel() else { return genericCardView }
            
            genericCardView.configureWith(displayModel)
            return genericCardView
        }

        func updateUIView(_ uiView: SpiralGenericCardView, context: Context) {
            guard let displayModel = displayModel() else { return }
            uiView.configureWith(displayModel)
        }
    }
}
