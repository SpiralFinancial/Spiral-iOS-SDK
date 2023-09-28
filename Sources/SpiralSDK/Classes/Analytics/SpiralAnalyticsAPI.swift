//
//  SpiralAnalyticsAPI.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 9/20/23.
//

import Foundation

class SpiralAnalyticsAPI: AnalyticsAPI {
    
    /*
     https://stage-analytics.spiral.us
     https://feature-analytics.spiral.us
     https://qa-analytics.spiral.us
     https://perftest-analytics.spiral.us
     https://us-east-2-sandbox1-analytics.spiral.us
     https://us-east-2-prod1-analytics.spiral.us
     */
    
    class var basePath: String {
        return "https://qa-analytics.spiral.us"
        
        switch Spiral.shared.config()?.environment {
        case .integration: return "https://stage-analytics.spiral.us"
        case .staging: return "https://qa-analytics.spiral.us"
        case .uat: return "https://us-east-2-prod1-analytics.spiral.us"
        case .production: return "https://us-east-2-prod1-analytics.spiral.us"
        default: return "https://us-east-2-sandbox1-analytics.spiral.us"
        }
    }
    
    override class func createAnalyticsEventsWithRequestBuilder(createAnalyticsEventBatchRequest: CreateAnalyticsEventBatchRequest, X_SPIRAL_CUSTOMER_ID: String? = nil, X_SPIRAL_REQUEST_ID: String? = nil) -> RequestBuilder<Void> {
        let localVariablePath = "/" + Spiral.apiVersion + "/analytics-event"
        let localVariableURLString = basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: createAnalyticsEventBatchRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "X-SPIRAL-CUSTOMER-ID": X_SPIRAL_CUSTOMER_ID?.encodeToJSON(),
            "X-SPIRAL-REQUEST-ID": X_SPIRAL_REQUEST_ID?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
