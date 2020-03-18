//
//  WC+String.swift
//  Word_Count
//
//  Created by 峰 on 2020/3/18.
//  Copyright © 2020 峰. All rights reserved.
//

import Foundation

/// 字符串处理的拓展方法
extension String {
    
    /// 去掉所有空格后的字符串
    var removeAllSapce: String {
        self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
      //使用正则表达式替换
        func pregReplace(pattern: String, with: String,
                         options: NSRegularExpression.Options = []) -> String {
            let regex = try! NSRegularExpression(pattern: pattern, options: options)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: NSMakeRange(0, self.count),
                                                  withTemplate: with)
        }
    
    /// 删除字符串前几位的字符
    /// - Parameter count: 移除的字符串数量
    mutating func removePerChars(count: Int) {
        let range = self.startIndex..<self.index(self.startIndex, offsetBy: count)
        self.removeSubrange(range)
        
    }
    
    /// 验证指令前缀中是否有对应格式。 若有，则去除
    /// - Parameter str: 指令格式
    mutating func verify(_ str: String) ->(Bool) {
        guard self.hasPrefix(str) else{
            return false
        }
        self.removePerChars(count: str.count)
        return true
    }
}

