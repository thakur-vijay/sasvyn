//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum AboutRecordMapper {

   nonisolated static func map(_ record: AboutRecord) -> About {
       return About(userId: record.userId, content: record.content)
    }

}

