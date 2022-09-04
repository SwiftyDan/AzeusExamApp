//
//  test.swift
//  Examination
//
//  Created by Dan Albert Luab on 9/2/22.
//

import Foundation
import UIKit
import SwiftyJSON

class Recipe : Codable{
    
    var reply: [PDFItem]?

   
    
    init(_ json: JSON) {
        reply = json["pdf-item"].array?.map{PDFItem($0)}
      
    }
}
class PDFItem : Codable{
    var filename:Array<String>?
   
    
    init(_ json: JSON) {
        filename = (json["filename"].arrayObject ?? [""]) as? [String]
    }
}


class FeedParser: NSObject, XMLParserDelegate {
private var rssItems: [Recipe] = []
private var currentElement = ""
private var currentTitle: String = "" {
    didSet {
        currentTitle =
            currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
private var currentCalories: String = "" {
    didSet {
        currentCalories =
            currentCalories.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
private var currentIngredients: String = "" {
    didSet {
        currentIngredients =
            currentIngredients.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    }
}

private var parserCompletionHandler: (([Recipe]) -> Void)?

func parseFeed(url: String, completionHandler: (([Recipe]) -> Void)?) {
    print(url,"HAAHAH")
    self.parserCompletionHandler = completionHandler

    let request = URLRequest(url: URL(string: url)!)
    let urlSession = URLSession.shared
    let task = urlSession.dataTask(with: request) { (data, response, error) in
        guard let data = data else {
            if let error = error {
                print (error.localizedDescription)
            }
            return
        }

        /// Parse our xml data
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    task.resume()
}

// MARK: - XML Parser Delegate

func parser(_ parser: XMLParser, didStartElement elementName: String,
            namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict:
    [String : String] = [:]) {
    currentElement = elementName
    if currentElement == "dish" {
        currentTitle = ""
        currentCalories = ""
        currentIngredients = ""
    }
}

func parser(_ parser: XMLParser, foundCharacters string: String) {
    switch currentElement {
    case "filename": currentTitle += string
    case "description": currentCalories += string
 
    default: break
    }
}

func parser(_ parser: XMLParser, didEndElement elementName: String,
            namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "item" {
//        let rssItem = Recipe(filename: currentTitle, description: currentCalories)
//        self.rssItems.append(rssItem)
        print(elementName,"HAHA")
    }
}

func parserDidEndDocument(_ parser: XMLParser) {
    parserCompletionHandler?(rssItems)
}

func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    print(parseError.localizedDescription)
}
}
