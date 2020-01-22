//
//  Publisher.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation

class Publisher {

    let session: UUID
    let url: URL

    init(session: UUID, url: URL = .endpoint) {
        self.session = session
        self.url = url
    }

    func publish(data: Data) {
        inspect("analytics | publisher | publish")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.timeoutInterval = 15
        request.allHTTPHeaderFields = [
            "content-type": "application/json",
            "session-id": session.uuidString.lowercased()
        ]

        let task = URLSession.shared.dataTask(with: request) { _, _, _ in }
        task.resume()
    }

}

private extension URL {
    static var endpoint: URL {
        URL(string: "https://analytics.rzeszot.pro/api/collector")!
    }
}
