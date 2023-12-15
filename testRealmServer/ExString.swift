//
//  ExString.swift
//  ChildStudies
//
//  Created by chenzhizs on 2023/11/06.
//

import Foundation

extension String {
    //zhong wen
    var pinyin: String {
        let str = NSMutableString(string: self)
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        return str as String
    }
    
    //Zhong Wen
    var PinYin: String {
        let str = NSMutableString(string: self)
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        return str.capitalized
    }
    
    //zhōng wén
    var pinyinS: String {
        return NSMutableString(string: self).applyingTransform(.mandarinToLatin, reverse: false)!
    }
    
    //zhōng wén
    var pinyinS_old : String {
        let str = NSMutableString(string: self)
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
        return str as String
    }
    
    //韵母 声符
    private var yunmuA_S : String {return "aāáǎà"}
    private var yunmuA_Array : [String] {
        return ["a","ā","á","ǎ","à"]
    }
    private var yunmuO_S : String {return "oōóǒò"}
    private var yunmuO_Array : [String] {
        return ["o","ō","ó","ǒ","ò"]
    }
    private var yunmuE_S : String {return "eēéěè"}
    private var yunmuE_Array : [String] {
        return ["e","ē","é","ě","è"]
    }
    private var yunmuI_S : String {return "iīíǐì"}
    private var yunmuI_Array : [String] {
        return ["i","ī","í","ǐ","ì"]
    }
    private var yunmuU_S : String {return "uūúǔù"}
    private var yunmuU_Array : [String] {
        return ["u","ū","ú","ǔ","ù"]
    }
    private var yunmuV_S : String {return "üǖǘǚǜ"}
    private var yunmuV_Array : [String] {
        return ["ü","ǖ","ǘ","ǚ","ǜ"]
    }
    
    ///韵母 声符 全部 array
    private var yunmu_S_Array : [String] {
        var array=[String]()
        array.append(yunmuA_S)
        array.append(yunmuO_S)
        array.append(yunmuE_S)
        array.append(yunmuI_S)
        array.append(yunmuU_S)
        array.append(yunmuV_S)
        return array
    }
    
    //全部韵母 声符 的 [[String]]
    private var yunmu_ArrayArray : [[String]] {
        var array=[[String]]()
        array.append(yunmuA_Array)
        array.append(yunmuO_Array)
        array.append(yunmuE_Array)
        array.append(yunmuI_Array)
        array.append(yunmuU_Array)
        array.append(yunmuV_Array)
        return array
    }
    
    //其他复杂的韵母 声符 的 [[String]]
    private var yunmuOther_ArrayArray : [[String]] {
        var array=[[String]]()
        array.append(["ai","āi","ái","ǎi","ài"])
        array.append(["ei","ēi","éi","ěi","èi"])
        array.append(["ui","uī","uí","uǐ","uì"])
        
        array.append(["ao","āo","áo","ǎo","ào"])
        array.append(["ou","ōu","óu","ǒu","òu"])
        
        array.append(["iu","iū","iú","iǔ","iù"])
        array.append(["ie","iē","ié","iě","iè"])
        array.append(["ue","uē","ué","uě","uè"])
        
        
        array.append(["an","ān","án","ǎn","àn"])
        array.append(["en","ēn","én","ěn","èn"])
        array.append(["in","īn","ín","ǐn","ìn"])
        array.append(["un","ūn","ún","ǔn","ùn"])
        
        array.append(["ang","āng","áng","ǎng","àng"])
        array.append(["eng","ēng","éng","ěng","èng"])
        array.append(["ing","īng","íng","ǐng","ìng"])
        array.append(["ong","ōng","óng","ǒng","òng"])
        return array
    }
    
    //获取当前汉字的 韵母声符
    //"捉".getYunmuArray()
    //["o", "ō", "ó", "ǒ", "ò"]
    private func getYunmuArray() -> [String] {
        let array=[String]()
        
        if(yunmuA_Array.contains(getShenDiaoFromHanzi)){
            return yunmuA_Array
        }
        if(yunmuO_Array.contains(getShenDiaoFromHanzi)){
            return yunmuO_Array
        }
        if(yunmuE_Array.contains(getShenDiaoFromHanzi)){
            return yunmuE_Array
        }
        if(yunmuI_Array.contains(getShenDiaoFromHanzi)){
            return yunmuI_Array
        }
        if(yunmuU_Array.contains(getShenDiaoFromHanzi)){
            return yunmuU_Array
        }
        if(yunmuV_Array.contains(getShenDiaoFromHanzi)){
            return yunmuV_Array
        }
        return array
    }
    
    //把一个拼音串，弄成一组5字符串的数组
    //getPinyinSArray(pinyinS:"zuō")
    //["zuo", "zuō", "zuó", "zuǒ", "zuò"]
    private func getPinyinSArray(pinyinS:String) -> [String] {
        var array=[String]()
        let getYunmuArray : [String]  = getYunmuArray()
        
        for i in 0 ..< getYunmuArray.count {
            var myString = pinyinS
            let replacementCharacter: Character = Character(getYunmuArray[i])
            let targetCharacter: Character = Character(getShenDiaoFromHanzi)

            if let range = myString.range(of: String(targetCharacter)) {
                myString.replaceSubrange(range, with: String(replacementCharacter))
                array.append(myString)
            }
        }
        return array
    }
    
    //从汉字中 或 拼音中， 获取当前拼音的全部音符的对应数组
    //"捉".getPinyinSArray
    //["zhuo", "zhuō", "zhuó", "zhuǒ", "zhuò"]
    //"ta".getPinyinSArray
    //["ta", "tā", "tá", "tǎ", "tà"]
    var getPinyinSArray : [String] {
        var array=[String]()
        array = getPinyinSArray( pinyinS: self.pinyinS)
        return array
    }
    
    //韵母 array
    private var yunmuArray: [Character] {
        var chaArray = [Character]()
        chaArray.append("a")
        chaArray.append("o")
        chaArray.append("e")
        chaArray.append("i")
        chaArray.append("u")
        chaArray.append("ü")
        return chaArray
    }
    
    //声母 array
    private var shengmuArray: [String] {
        var strArray = [String]()
        strArray.append("b")
        strArray.append("p")
        strArray.append("m")
        strArray.append("f")
        
        strArray.append("d")
        strArray.append("t")
        strArray.append("n")
        strArray.append("l")
        
        strArray.append("g")
        strArray.append("k")
        strArray.append("h")
        
        strArray.append("j")
        strArray.append("q")
        strArray.append("x")
        
        strArray.append("zh")
        strArray.append("ch")
        strArray.append("sh")
        
        strArray.append("r")
        
        strArray.append("z")
        strArray.append("c")
        strArray.append("s")
        
        strArray.append("y")
        strArray.append("w")
        return strArray
    }
    
    //是否发现想找的声母
    //"大".isFindShengMu(str: "b")
    //true
    private func isFindShengMu(str:String) -> Bool {
        for i in 0 ..< shengmuArray.count {
            if(shengmuArray[i]==str){
                return true
            }
        }
        return false
    }
    
    //是否包含想找的声母
    //isFindShengMu(pinyin: "gang")
    //true
    private func isContainsShengMu(pinyin:String) -> Bool {
        for i in 0 ..< shengmuArray.count {
            if pinyin.contains(shengmuArray[i]) {
                return true
            }
        }
        return false
    }
    
    //是否发现想找的韵母
    //isFindYunmu(Cha:"m")
    //false
    private func isFindYunmu(Cha:Character) -> Bool {
        for i in 0 ..< yunmuArray.count {
            if(yunmuArray[i]==Cha){
                return true
            }
        }
        return false
    }
    
    //是否包含想找的韵母
    //isFindYunmu(Cha:"m")
    //false
    private func isContainsYunmu(pinyin:String) -> Bool {
        for i in 0 ..< yunmuArray.count {
            if pinyin.contains(yunmuArray[i]) {
                return true
            }
        }
        return false
    }
    
    //韵母 位置
    //yunmuPosition(pinyin:"ke")
    //1
    private func yunmuPosition(pinyin:String) -> Int{
        var r = -1
        for i in 0 ..< yunmuArray.count {
            if let index = pinyin.firstIndex(of: yunmuArray[i]) {
                let position = pinyin.distance(from: pinyin.startIndex, to: index) // 获取位置
                if(r>position || r == -1){
                    r = position
                }
            }
        }
        return r
    }
    
    //韵母 位置
    //print("大".yunmuPosition)
    //1   ---  "大",的第二个字母是韵母，所以是1
    var yunmuPosition : Int {
        return yunmuPosition(pinyin: self.pinyin)
    }
    
    
    //拼音获取声母
    //"ch".pinyinGetShengmu
    //ch
    var pinyinGetShengmu : String {
        let str = self
        if(isContainsShengMu(pinyin:str) ){
            if(isContainsYunmu(pinyin:str)){
                let yunmuPosition = yunmuPosition(pinyin: self.pinyin )
                
                let originalString = str
                let startIndex = originalString.index(originalString.startIndex, offsetBy: 0)
                let endIndex = originalString.index(originalString.startIndex, offsetBy: yunmuPosition)

                let substring = String(originalString[startIndex..<endIndex])
                return substring
            }else{
                return str
            }
        }
        
        return ""
    }
    
    
    //拼音获取韵母
    //"zhuo".pinyinGetYunmu
    //uo
    var pinyinGetYunmu : String {
        let str = self
        if(isContainsShengMu(pinyin:str) ){
            if(isContainsYunmu(pinyin:str)){
                let yunmuPosition = yunmuPosition(pinyin: self.pinyin )
                
                let originalString = str
                let startIndex = originalString.index(originalString.startIndex, offsetBy: yunmuPosition)
                let endIndex = originalString.index(originalString.startIndex, offsetBy: str.count)

                let substring = String(originalString[startIndex..<endIndex])
                return substring
            }
        }else{
            if(isContainsYunmu(pinyin:str)){
                return str
            }
        }
        
        return ""
    }
    
    //拼音获取韵母
    //"zhèn".pinyinSGetYunmu
    //èn
    var pinyinSGetYunmu : String {
        let str = self
        if(isContainsShengMu(pinyin:str) ){
            if(isContainsYunmu(pinyin:str)){
                let yunmuPosition = yunmuPosition(pinyin: self.pinyinS )
                
                let originalString = str
                let startIndex = originalString.index(originalString.startIndex, offsetBy: yunmuPosition)
                let endIndex = originalString.index(originalString.startIndex, offsetBy: str.count)

                let substring = String(originalString[startIndex..<endIndex])
                return substring
            }
        }else{
            if(isContainsYunmu(pinyin:str)){
                return str
            }
        }
        
        return ""
    }
    
    //在pinyinS中，获取声符的位置
    //getShenDiaoPosition(pinyinS: "捉".pinyinS)
    //3
    private func getShenDiaoPosition(pinyinS:String) -> Int{
        //先从四声āáǎà 中 抽
        for i in 0 ..< yunmu_S_Array.count {
            let originalString = yunmu_S_Array[i]
            let startIndex = originalString.index(originalString.startIndex, offsetBy: 1)
            let endIndex = originalString.index(originalString.startIndex, offsetBy: 5)

            let substring = String(originalString[startIndex..<endIndex])
            
            
            let pinyinCharArray =  pinyinS.map{ $0 }
            //pinyinCharArray
            
            for j in 0 ..< pinyinCharArray.count {
                if(substring.contains(pinyinCharArray[j])){
                    return j
                }
            }
        }
        
        //再从五声aāáǎà 中 抽
        for i in 0 ..< yunmu_S_Array.count {
            let originalString = yunmu_S_Array[i]
            let startIndex = originalString.index(originalString.startIndex, offsetBy: 0)
            let endIndex = originalString.index(originalString.startIndex, offsetBy: 5)

            let substring = String(originalString[startIndex..<endIndex])
            
            
            let pinyinCharArray =  pinyinS.map{ $0 }
            //pinyinCharArray
            
            for j in 0 ..< pinyinCharArray.count {
                if(substring.contains(pinyinCharArray[j])){
                    return j
                }
            }
        }
        
        return  -1
    }
    
    
    //从pinyinS中，有声符的韵母
    //getShenDiao(pinyinS: "捉".pinyinS)
    //ō
    private func getShenDiao(pinyinS:String) -> Character{
        let cha : Character = " "
        //声符的位置
        let getShenDiaoPosition = getShenDiaoPosition(pinyinS:pinyinS)
        if(getShenDiaoPosition > -1){
            let index = pinyinS.index(pinyinS.startIndex, offsetBy: getShenDiaoPosition)

            return pinyinS[index]
        }
        
        return cha
    }
    
    //"捉".getShenDiaoFromHanzi  "了".getShenDiaoFromHanzi
    //ō                          e
    ///从 汉字 中，获取带有声符的韵母
    var getShenDiaoFromHanzi : String{
        let str = self
        let myCharacter: Character = getShenDiao(pinyinS: str.pinyinS)
        return String(myCharacter)
    }
    
    //"捉".getAllShenDiaoArrayFromHanzi
    //["oōóǒò"]
    ///从汉字中，获取全部声道的韵母数组
    var getAllShenDiaoArrayFromHanzi : [String]{
        var strArray = [String]()
        yunmu_S_Array.forEach { yunmu_S in
            if(yunmu_S.contains(self.getShenDiaoFromHanzi)){
                if(!strArray.contains(self.pinyinS)){
                    strArray.append(yunmu_S)
                }
            }
        }
        return strArray
    }
    
    //"中".hangziGetShengmu
    //zh
    ///汉字获取声母
    var hangziGetShengmu : String {
        let str = self
        let pingyin = str.pinyin
        return pingyin.pinyinGetShengmu
    }
    
    //汉字获取韵母
    //"捉".hangziGetYunmu
    //uo
    var hangziGetYunmu : String {
        let str = self
        let pingyin = str.pinyin
        return pingyin.pinyinGetYunmu
    }
    
    var yunmuCharacterA: [Character] {
        var cha = [Character]()
        yunmuA_S.forEach { Character in
            cha.append(Character)
        }
        return cha
    }
    var yunmuCharacterO: [Character] {
        var cha = [Character]()
        yunmuO_S.forEach { Character in
            cha.append(Character)
        }
        return cha
    }
    var yunmuCharacterE: [Character] {
        var cha = [Character]()
        yunmuE_S.forEach { Character in
            cha.append(Character)
        }
        return cha
    }
    var yunmuCharacterI: [Character] {
        var cha = [Character]()
        yunmuI_S.forEach { Character in
            cha.append(Character)
        }
        return cha
    }
    var yunmuCharacterU: [Character] {
        var cha = [Character]()
        yunmuU_S.forEach { Character in
            cha.append(Character)
        }
        return cha
    }
    var yunmuCharacterV: [Character] {
        var cha = [Character]()
        yunmuV_S.forEach { Character in
            cha.append(Character)
        }
        return cha
    }
    
    //随机的生成拼音 不带 声调
    var getRandomPinyin : String{
        var r = ""
        let shenmu = shengmuArray.randomElement()
        var yunmu = ""
        if(Int.random(in: 0...4)>1){
            yunmu = yunmuOther_ArrayArray.randomElement()?.first ?? ""
        }else{
            yunmu = yunmu_ArrayArray.randomElement()?.first ?? ""
        }
        r = shenmu?.appending(yunmu ) ?? ""
        
        return r
    }
    
    ///随机的生成拼音 带 声调
    var getRandomPinyinS : String{
        var r = ""
        let shenmu = shengmuArray.randomElement()
        var yunmu = ""
        if(Int.random(in: 0...4)>1){
            yunmu = yunmuOther_ArrayArray.randomElement()?.randomElement() ?? ""
        }else{
            yunmu = yunmu_ArrayArray.randomElement()?.randomElement() ?? ""
        }
        r = shenmu?.appending(yunmu ) ?? ""
        
        return r
    }
    
    ///同声母 随机的生成拼音 带 声调
    public func getSameShenmuRandomPinyinS() -> String{
        var r = ""
        let shenmu = hangziGetShengmu
        var yunmu = ""
        if(Int.random(in: 0...4)>1){
            yunmu = yunmuOther_ArrayArray.randomElement()?.randomElement() ?? ""
        }else{
            yunmu = yunmu_ArrayArray.randomElement()?.randomElement() ?? ""
        }
        r = shenmu.appending(yunmu )
        
        return r
    }
}
