//
//  NetworkLoggingPlugin.swift
//  rosbank-ios
//
//  Created by Денис Николаев on 14.06.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import Foundation
import Moya

/// Logs network activity (outgoing requests and incoming responses).
final class NetworkLoggingPlugin: PluginType {
    
    /// If true, also logs response body data.
    var isVerbose: Bool
    let cURL: Bool
    
    private let separator = [",", .whitespace()].joined()
    private let terminator = String.newLine
    private let cURLTerminator = ["\\", .newLine].joined()
    private let output: (_ separator: String, _ terminator: String, _ items: Any...) -> Void
    private let requestDataFormatter: ((Data) -> (String))?
    private let responseDataFormatter: ((Data) -> (Data))?
    
    init(cURL: Bool = false,
         output: @escaping ((_ separator: String, _ terminator: String, _ items: Any...) -> Void) = NetworkLoggingPlugin.reversedPrint,
         requestDataFormatter: ((Data) -> (String))? = nil,
         responseDataFormatter: ((Data) -> (Data))? = JSONResponseDataFormatter) {
        self.cURL = cURL
        #if DEBUG
        self.isVerbose = true
        #else
        self.isVerbose =  false
        #endif
        self.output = output
        self.requestDataFormatter = requestDataFormatter
        self.responseDataFormatter = responseDataFormatter
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        
        if let request = request as? CustomDebugStringConvertible, cURL {
            output(separator, terminator, request.debugDescription)
            return
        }
        outputItems(logNetworkRequest(request.request as URLRequest?))
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            outputItems(logNetworkResponse(response.response, data: response.data, target: target))
        } else {
            outputItems(logNetworkResponse(nil, data: nil, target: target))
        }
    }
    
    private func outputItems(_ items: String) {
        output(separator, terminator, items)
    }
}

private extension NetworkLoggingPlugin {
    
    
    func format(identifier: String, message: String) -> String {
        return "\(identifier): \(message) \(String.newLine)"
    }
    
    func logNetworkRequest(_ request: URLRequest?) -> String {
        
        var output: String = .empty
        
        if let httpMethod = request?.httpMethod {
            output += format(identifier: "HTTP Request Method", message: httpMethod)
        }
        
        output += format(identifier: "Request", message: request?.description ?? "(invalid request)")
        
        if let headers = request?.allHTTPHeaderFields {
            output += format(identifier: "Request Headers", message: headers.description)
        }
        
        if let bodyStream = request?.httpBodyStream {
            output += format(identifier: "Request Body Stream", message: bodyStream.description)
        }
        
        if let body = request?.httpBody, let stringOutput = requestDataFormatter?(body) ?? String(data: body, encoding: .utf8), isVerbose {
            output += format(identifier: "Request Body", message: stringOutput)
        }
        
        return output
    }
    
    func logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> String {
        guard let response = response else {
            return format(identifier: "Response", message: "⚠️ Received empty network response for \(target).")
        }
        
        var output: String = .empty
        
        if 200..<400 ~= (response.statusCode) {
            output += "✅"
        } else {
            output += "🛑"
        }
        output += format(identifier: "Response", message: "Status Code: \(response.statusCode)  URL:\(response.url?.absoluteString ?? .empty)")
        
        if let data = data, let stringData = String(data: responseDataFormatter?(data) ?? data, encoding: String.Encoding.utf8), isVerbose {
            output += stringData
            output += .newLine
        }
        
        return output
    }
}

fileprivate extension NetworkLoggingPlugin {
    
    static func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            print("[✈️]" + "\(item)" + .newLine)
        }
    }
}

fileprivate func JSONResponseDataFormatter(data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}


extension String {
    
    static var empty: String { return "" }
    
    static var newLine: String { return "\n" }
    
    static func whitespace(count: Int = 1) -> String {
        return String(repeating: " ", count: count)
    }
}

