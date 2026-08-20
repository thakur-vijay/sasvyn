//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum SkillRecordMapper {

   nonisolated static func map(_ record: SkillRecord) -> Skill? {

       guard let category = SkillCategory(rawValue: record.category) else {

            return nil

        }

       return Skill(id: record.id, skill: record.skill, category: category)
    }

}

