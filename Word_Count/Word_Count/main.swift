//
//  main.swift
//  Word_Count
//
//  Created by 峰 on 2020/3/16.
//  Copyright © 2020 峰. All rights reserved.
//


import Foundation

let manager = WordCountManager()
// 二级指令操作  wc.exe -a /Users/feng/Desktop/data/test.txt
// wc.exe -a /Users/feng/Desktop/测试/test.txt
manager.operatingSecond()
// 一级指令操作  wc.exe -l /Users/feng/Desktop/data/test.txt
manager.operatingFirst()



