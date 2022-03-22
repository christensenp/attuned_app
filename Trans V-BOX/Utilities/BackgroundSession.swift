//
//  BackgroundSession.swift
//  Trans V-BOX
//
//  Created by Gourav on 18/06/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class BackgroundSession: NSObject {
    static let shared = BackgroundSession()

    static let identifier = "com.domain.app.bg"

    private var session: URLSession!
    var handler: DataCompletionBlock!
    #if !os(macOS)
    var savedCompletionHandler: (() -> Void)?
    #endif

    private override init() {
        super.init()

        let configuration = URLSessionConfiguration.background(withIdentifier: BackgroundSession.identifier)
        configuration.sessionSendsLaunchEvents = true
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
    }

    func start(_ request: URLRequest, completionHandler: @escaping DataCompletionBlock) {
        self.handler = completionHandler
        session.dataTask(with: request).resume()
    }
}

extension BackgroundSession: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print(uploadProgress)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            handler(nil, 400, "\(error.localizedDescription)")
        }
    }

    #if !os(macOS)
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            self.savedCompletionHandler?()
            self.savedCompletionHandler = nil
        }
    }
    #endif

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                let model = SettingsModel.init(object: json)
                handler(model, 200, nil)
            } else {
                handler(nil, 200, nil)
            }
        } catch {
            handler(nil, 400, "\(error.localizedDescription)")
        }
    }

}
