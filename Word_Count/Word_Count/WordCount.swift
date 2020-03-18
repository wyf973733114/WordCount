//
//  WordCount.swift
//  Word_Count
//
//  Created by 峰 on 2020/3/17.
//  Copyright © 2020 峰. All rights reserved.
//

import Foundation

/// 文件信息读取类
class WordCount {
    
    /// 属性对外只可读，防外部进行更改
    private(set) var message: String
    private(set) var spaceLineCount = 0 // 空行数
    private(set) var codeLineCount = 0  // 代码行数
    private(set) var noteLineCount = 0  // 注释行数
    private(set) var path: String = ""   // 路径
    
    /// 文件内容的行数 （只读）
    var lineCount: Int {
        get {
            var count = 0
            message.enumerateLines { _,_ in
                count += 1  // 计数
            }
            return count
        }
    }
    
    /// 文件单词数
    var  wordCount: Int {
        get {
            let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
            // 根据 标点符号、空格、换行 进行单词计算
            let components = message.components(separatedBy: chararacterSet)
            let words = components.filter { !$0.isEmpty }   // 滤去空白的单词
            return words.count
        }
    }
    
    /// 文件字符数，包括换行符和j空格符等
    var charCount: Int {
        get {
            return message.count
        }
    }
    /// 可失败初始化器
    /// - Parameter filePath: 文件路径
    init?(_ filePath: String?) {
        var success = false
        (success,message) = WordCount.readFile(filePath)
        if success {
            path = filePath!
        }else {
            // 初始化失败
            print(message)
            return nil
        }
        
    }

    /// 类方法（读取文件），返回(Bool, String)。Bool标志文件读取是否成功，成功时String中为读取的数据，失败时String中为失败的原因，
    /// - Parameter filePath: 文件路径
    static func readFile(_ filePath: String?) -> (Bool, String) {

        // 文件管理者
        let manager = FileManager.default
        guard let data = manager.contents(atPath: filePath ?? "") else {
            return (false,"找不到文件")  // 根据传入参数找不到内容
        }
        
        guard  let readString = String(data: data, encoding: String.Encoding.utf8) else {
            return (false,"数据解析失败")    // 数据解析编码格式错误
        }
        
        return (true, readString)
    }
    
    func dealCode() {
        //只执行一次
        var noteFlag = false
        message.enumerateLines { (line, false) in
            self.lineType(line, noteFlag: &noteFlag)
        }
    }
    /// 传入一行字符，判断其类型（对应的属性计数将会增加）
    private func lineType(_ line: String, noteFlag: inout Bool) {
        // 正则去空格和特殊字符（预处理）、后续需求更改特殊字符的集合时可以在这里修改
        let code = line.pregReplace(pattern: "[{|}| |(|)]", with: "")
        // 1. 先判断是不是注释
        if self.isNote(code, noteFlag: &noteFlag) {
            return
        }
        // 2. 再判断是不是空行 （字符串已经过预处理，只含空格和特殊字符的被解释为空行）
        if code.count == 0 {
            //代码中除空格字符外，其他字符数量大于1，为代码行
            spaceLineCount += 1
            return
        }
        // 3. 剩下的是代码行
        codeLineCount += 1
    }

    /// 判断该行是否是注释
    /// - Parameters:
    ///   - code: 需要判断的哪一行字符串
    ///   - noteFlag: 判断是否属于注释块中（/* 这中间可能会换行，然后写代码，此时将其中的代码解释为注释 */）
    private func isNote(_ code: String, noteFlag: inout Bool) -> Bool{
        var increased = false   //  标志是否是注释行
        
        if code.contains("/*") {
            noteFlag = true
        }
        if noteFlag || code.hasPrefix("//") {
            self.noteLineCount += 1
            increased = true
        }
        if code.contains("*/") {
            noteFlag = false
        }
        return increased
    }
}
