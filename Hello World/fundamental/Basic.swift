//
//  Basic.swift
//  Hello World
//
//  Created by Harry Jason on 08/05/2021.
//

import Foundation

var doOnNext : ((String) -> String) = {input in return ""}

func main(){
    
    /*  Module 2
        Part 1
     */

    var mutableName = "Naing Aung Luu"
    mutableName = "Something else"
    debugPrint(mutableName)
    
    let inmutableName = "Naing Aung Luu"
//    inmutableName = "Something else" //Error
    debugPrint(inmutableName)
    
    
    
    /*  Module 2
        Part 2 & 3
     */
    
    var colorList : [String] = ["Red" , "Yellow" , "Blue"]
    colorList = ["New Red" , "New Yellow" , "New Blue"]
    colorList.append("New Green")
    
    let inmutableColorList : [String] = ["Red" , "Yellow" , "Blue"]
//    inmutableColorList = ["New Red"] // Error
    debugPrint(inmutableColorList)
    
    var regionList : Set = ["Yangon" , "Mandalay" , "Bago"]
    regionList.insert("Sagaing")
    debugPrint(regionList)
    
    let cityList : [String : [String]] = ["Yangon" : ["Tamwe" , "Yankin" , "Insein"]]
    
    
    
    
    /*  Module 2
        Part 4
     */
    
    //For Loop
    
    for color in colorList {
        debugPrint(color)
    }
    
    // While Loop
    
    var index = 0
    while index < colorList.count {
        debugPrint(colorList[index])
        index += 1
    }
    
    var indexForRepeat = 0
    repeat {
        debugPrint(indexForRepeat)
        indexForRepeat += 1
    }while indexForRepeat < colorList.count
    
    
    /*  Module 2
        Part 5
     */
    
    doOnNext = { name -> String in
        return "I'm Closure! and my name is \(name)"
    }


    func increment(amount : Int) -> (() -> Int) {
        let total = 0
        
        func incrementTotal() -> Int {
            return total
        }
        
        return incrementTotal
    }
    
    // let incrementTotal = increment(amount: 10)()
    
    let nestedClosure : () -> ((String) -> Void) = {
        return { argument in
            debugPrint("Hello \(argument)")
        }
    }
    
    nestedClosure()("Argument String")
    
    func decrease(total : Int , doDecrement:()->Void) -> Void {
        doDecrement()
    }
    
    decrease(total: 10) {
        debugPrint("Inside decrease function")
    }
    
}
