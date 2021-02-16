//
//  WLEDService.swift
//  WLED Switch
//
//  Created by Roman Gille on 25.01.21.
//

import Foundation
import AppKit

class WLEDService {

    typealias SetStatusCompletion = (Result<String, Error>) -> Void

    enum RequestError: Error {
        case unknown
        case address
    }

    let host: String
    private let session: URLSession

    init(host: String, session: URLSession = .shared) {
        self.host = host
        self.session = session
    }

    @discardableResult
    func setStatus(_ status: LEDStatus, completion: SetStatusCompletion? = nil) -> URLSessionTask? {

        let path = "\(host)/json/state"

        guard let url = URL(string: path) else {
            completion?(.failure(RequestError.address))
            return nil
        }

        let segment: [String: Any] = [
            "col": [
                [
                    status.color.redComponent,
                    status.color.greenComponent,
                    status.color.blueComponent,
                ].map { round($0 * 255) },
                [0, 0, 0],
                [0, 0, 0]
            ]
        ]
        let parameters: [String: Any] = ["seg": [segment]]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)

        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in

            guard let json: String = data.flatMap({ String(data: $0, encoding: .utf8) }), error == nil else {
                completion?(.failure(error ?? RequestError.unknown))
                return
            }
            completion?(.success(json))
        }
        task.resume()

        return task
    }
}
