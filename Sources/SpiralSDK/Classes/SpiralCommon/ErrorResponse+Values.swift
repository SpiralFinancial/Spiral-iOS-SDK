//
//  ErrorResponse+Values.swift
//  SpiralSDK
//
//  Created by Ron Soffer on 1/19/23.
//

import Foundation

public extension ErrorResponse {
    var statusCode: Int {
        switch self {
        case let .error(status, _, _, _): return status
        }
    }
    
    var data: Data? {
        switch self {
        case let .error(_, data, _, _): return data
        }
    }
    
    var response: URLResponse? {
        switch self {
        case let .error(_, _, response, _): return response
        }
    }
    
    var error: Error {
        switch self {
        case let .error(_, _, _, error): return error
        }
    }
}
