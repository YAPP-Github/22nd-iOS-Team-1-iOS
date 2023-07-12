//
//  GetReviewsRequestDTO.swift
//  Network
//
//  Created by Min Min on 2023/07/13.
//  Copyright © 2023 kr.co.yapp. All rights reserved.
//

import Foundation

public struct GetReviewsRequestDTO: Encodable {
  public let pageSize: Int
  public let lastSeenReviewId: Int?
}
