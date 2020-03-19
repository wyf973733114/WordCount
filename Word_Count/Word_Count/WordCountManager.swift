//
//  WordCountManager.swift
//  Word_Count
//
//  Created by 峰 on 2020/3/17.
//  Copyright © 2020 峰. All rights reserved.
//

import Foundation

class WordCountManager {
    var wordCounts: [WordCount] = []
    var path: String = ""
    // 使用数组便于指令拓展
    // 一级指令数组（对单个文件），先后次序会影响操作的优先级（左边最高）
    let parametersFirst = ["-a", "-c", "-w", "-l"]
    // 二级指令数组（对于文件夹），暂时只有一个二级指令
    let parametersSecond = ["-s"]
    
    // 要进行的一级指令操作数组
    var operationsFirst:[String] = []
    // 要进行的二级指令操作数组
    var operationsSecond:[String] = []
    
    init() {
        ///输入指令进行构造
        while wordCounts.count == 0 {
            operationsFirst.removeAll()
            operationsSecond.removeAll()
            
            guard let input = readLine() else {
                //  测试环境下会触发，真实运行环境下不会触发
                debugPrint("输入不可为空")
                continue
            }
            // 1. 去空格形成指令
            var command = input.removeAllSapce
            
            // 2. 验证指令命令 - "wc.exe"
            guard command.verify("wc.exe") else {
                print("指令错误")
                continue
            }
            // 2.1. 验证二级指令
            for item in parametersSecond {
                if command.verify(item){
                    operationsSecond.append(item)
                }
            }
            // 2.2. 验证一级指令
            for item in parametersFirst {
                if command.verify(item){
                    operationsFirst.append(item)
                }
            }
            // 2.3 没有输入指令
            if operationsFirst.count + operationsSecond.count == 0 {
                print("没有输入的指令")
                continue
            }
            
            // 3. 存储剩下的文件路径
            path = command
            if let _ = WordCount(path){
                // 路径有效则停止构建
                break
            }
        }
    }
    
    /// 根据二级指令数组对文件夹进行操作（这样写是为了方便拓展）
    func operatingSecond() {
        for item in operationsSecond {
            switch item {
            case "-s":
                //文件管理
                let manager = FileManager.default
                // 文件名
                let fileName = (path as NSString).lastPathComponent
                // 路径
                let folder = (path as NSString).deletingLastPathComponent
                
                guard let subPaths = manager.subpaths(atPath: folder) else {
                    print("找不到子文件或子文件夹")
                    return
                }
                for subPath in subPaths {
                    if (subPath as NSString).lastPathComponent == fileName,
                        let wordCount = WordCount(folder + "/" + subPath) {
                        wordCounts.append(wordCount)
                    }
                }
                break
            default:
                break
            }
        }
    }
    
    /// 根据一级指令数组对单个文件进行操作
    func operatingFirst() {
        // 若二级指令为空，传递文件路径进行读取、计算
        if operationsSecond.count == 0, let wordCount = WordCount(path){
            wordCounts.append(wordCount)
        }
        for wordCount in wordCounts {
            print(wordCount.path)
            // 如果进行了二级指令，将会对多个文件进行相同的操作
            for item in operationsFirst {
                switch item {
                case "-a":
                    // 进行代码模式处理
                    wordCount.dealCode()
                    print("文件空行数为\(wordCount.spaceLineCount)")
                    print("文件代码行数为\(wordCount.codeLineCount)")
                    print("文件注释行数为\(wordCount.noteLineCount)")
                    break
                case "-c":
                    print("文件字符数为\(wordCount.charCount)")
                    break
                case "-w":
                    print("文件单词数为\(wordCount.wordCount)")
                    break
                case "-l":
                    print("文件行数为：\(wordCount.lineCount)")
                    break
                default:
                    print("指令未实现")
                    break
                }
            }
        }
    }
}
