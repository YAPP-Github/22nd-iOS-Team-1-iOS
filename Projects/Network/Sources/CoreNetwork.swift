//
//  CoreNetwork.swift
//  Network
//
//  Created by 천수현 on 2023/06/16.
//  Copyright © 2023 com.cafe. All rights reserved.
//

import Foundation

public enum CoreNetworkError: Error {
  case noAuthToken
  case invalidResponse(statusCode: Int)
  case sessionError
  case jsonParseFailed
  case exceptionParseFailed
  case exception(errorMessage: String)
  case responseConvertFailed
}

protocol CoreNetworkInterface {
  var baseURL: String { get }
  func dataTask<DTO: Decodable>(request: URLRequest) async throws -> DTO
  func dataTask(request: URLRequest) async throws -> HTTPURLResponse
}

final class CoreNetwork: CoreNetworkInterface {
  static let shared = CoreNetwork()

  var baseURL: String {
    guard let path = Bundle.main.path(forResource: "SecretAccessKey", ofType: "plist"),
          let dictionary = NSDictionary(contentsOfFile: path),
          let baseURL = dictionary["BASE_URL"] as? String else { return "" }
    return baseURL
  }

  private var token: String? {
    if let token = KeychainManager.shared.getItem(key: "token") as? String {
      return token
    } else if let lookAroundToken = KeychainManager.shared.getItem(key: "lookAroundToken") as? String {
      return lookAroundToken
    }
    return nil
  }

  private init() { }

  // DTO가 반환되길 원할때 사용하는 메서드입니다.
  func dataTask<DTO: Decodable>(request: URLRequest) async throws -> DTO {
    var request = request
    if let token = token {
      request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    } else {
      print("There is no jwt token")
    }
    let (data, response) = try await URLSession.shared.data(for: request)
    print("🌐 " + (request.httpMethod ?? "") + " : " + String(request.url?.absoluteString ?? ""))
    guard let httpResponse = response as? HTTPURLResponse,
          200...299 ~= httpResponse.statusCode else {
      guard let exception = try? JSONDecoder().decode(NetworkException.self, from: data) else {
        print("🚨 data: " + (String(data: data, encoding: .utf8) ?? ""))
        throw CoreNetworkError.exceptionParseFailed
      }
      print("🚨 status: \(exception.status) \n message: \(exception.message)")
      throw CoreNetworkError.exception(errorMessage: exception.message)
    }

    guard let dto = try? JSONDecoder().decode(NetworkResult<DTO>.self, from: data).data else {
      throw CoreNetworkError.jsonParseFailed
    }
    print("✅ status: \(httpResponse.statusCode)")
    return dto
  }

  /// DTO가 아닌 Response만 필요한 경우, 혹은 사용 가능한 경우에 호출하는 메서드입니다.
  func dataTask(request: URLRequest) async throws -> HTTPURLResponse {
    return try await withCheckedThrowingContinuation({ continuation in
      URLSession.shared.dataTask(with: request) { data, response, error in
        if error != nil {
          continuation.resume(throwing: CoreNetworkError.sessionError)
          return
        }
        print("🌐 request: " + String(response?.url?.absoluteString ?? ""))
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
          continuation.resume(throwing: CoreNetworkError.responseConvertFailed)
          print("🚨 response convert Failed")
          return
        }

        print("✅ status: \(httpResponse.statusCode)")
        continuation.resume(returning: httpResponse)
      }.resume()
    })
  }
}
