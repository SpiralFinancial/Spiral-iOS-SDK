// https://github.com/Quick/Quick

import Quick
import Nimble
import SpiralSDK
import WebKit

class SpiralVCDelegate: SpiralDelegate {
    public var onEventName: SpiralEventType?
    public var onEventPayload: SpiralEventPayload?
    public var onExitPayload: SpiralError?
    public var onSuccessPayload: SpiralSuccessPayload?
    public var onErrorPayload: SpiralError?
    
    func onEvent(name: SpiralEventType, event: SpiralEventPayload?) {
        onEventName = name
        onEventPayload = event
    }
    
    func onExit(_ error: SpiralError?) {
        onExitPayload = error
    }
    
    func onSuccess(_ result: SpiralSuccessPayload) {
        onSuccessPayload = result
    }
    
    func onError(_ error: SpiralError) {
        onErrorPayload = error
    }
}

class TestMessage: WKScriptMessage {
    var messageName: String
    var bodyString: String
    
    override public var name: String {
        get {
            return messageName
        }
    }
    
    override public var body: Any {
        get {
            return bodyString
        }
    }
    
    init(_ name: String, body: String) {
        self.messageName = name
        self.bodyString = body
    }
}

class TableOfContentsSpec: QuickSpec {
    override func spec() {
//        let spiralToken = "abc-123"
        let config = SpiralConfig(mode: .sandbox,
                                  environment: .staging,
                                  clientId: "CUST12345",
                                  customerId: "d2f2d15c-8198-4bfe-9752-505b49a9b970")
        
        Spiral.shared.setup(config: config)
        
        describe("Spiral") {
            
            it("onEvent is called for open") {
                let delegate = SpiralVCDelegate()
                let userContentController = WKUserContentController()
                let body: JSONDictionary = [
                    "type": "SPIRAL_EVENT",
                    "eventName": "open"
                ]
                let message = TestMessage("openEventHandler", body: asString(jsonDictionary: body))
                let spiralVC = SpiralViewController(flow: .donation, delegate: delegate)
                spiralVC.userContentController(userContentController, didReceive: message)
                expect(delegate.onEventName?.rawValue).to(equal("open"))
            }
            
            it("onEvent is called for success") {
                let delegate = SpiralVCDelegate()
                let userContentController = WKUserContentController()
                let body: JSONDictionary = [
                    "type": "SPIRAL_EVENT",
                    "eventName": "success",
                    "payload": [
                        "result": true
                    ]
                ]
                let bodyString = asString(jsonDictionary: body)
                let message = TestMessage("successEventHandler", body: bodyString)
                let spiralVC = SpiralViewController(flow: .donation, delegate: delegate)
                spiralVC.userContentController(userContentController, didReceive: message)
                let payload = delegate.onEventPayload as? SpiralSuccessPayload
                expect(payload?.result).to(equal(true))
            }
            
            it("onEvent is called for success with false") {
                let delegate = SpiralVCDelegate()
                let userContentController = WKUserContentController()
                let body: JSONDictionary = [
                    "type": "SPIRAL_EVENT",
                    "eventName": "success",
                    "payload": [
                        "result": false
                    ]
                ]
                let bodyString = asString(jsonDictionary: body)
                let message = TestMessage("successEventHandler", body: bodyString)
                let spiralVC = SpiralViewController(flow: .donation, delegate: delegate)
                spiralVC.userContentController(userContentController, didReceive: message)
                let payload = delegate.onEventPayload as? SpiralSuccessPayload
                expect(payload?.result).to(equal(false))
            }
            
            it("onEvent is called for error") {
                let delegate = SpiralVCDelegate()
                let userContentController = WKUserContentController()
                let body: JSONDictionary = [
                    "type": "SPIRAL_EVENT",
                    "eventName": "error",
                    "payload": [
                        "type": "invalidUserInput",
                        "code": "invalidCredentials",
                        "message": "Uh oh",
                    ]
                ]
                let bodyString = asString(jsonDictionary: body)
                let message = TestMessage("errorEventHandler", body: bodyString)
                let spiralVC = SpiralViewController(flow: .donation, delegate: delegate)
                spiralVC.userContentController(userContentController, didReceive: message)
                let payload = delegate.onEventPayload as? SpiralError
                expect(payload?.type).to(equal("invalidUserInput"))
                expect(payload?.code).to(equal("invalidAmount"))
                expect(payload?.message).to(equal("Uh oh"))
            }
        }
    }
}

typealias JSONDictionary = [String : Any]

func asString(jsonDictionary: JSONDictionary) -> String {
  do {
    let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
    return String(data: data, encoding: String.Encoding.utf8) ?? ""
  } catch {
    return ""
  }
}
