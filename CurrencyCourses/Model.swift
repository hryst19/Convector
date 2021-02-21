//
//  Model.swift
//  CurrencyCourses
//
//  Created by hryst on 7/18/19.
//  Copyright © 2019 Anton Mikliayev. All rights reserved.
//

import UIKit

class Currency {
    var NumCode: String?
    var CharCode: String?
    var Scale: String?
    var scaleDouble: Double?
    
    var Name: String?
    
    var Rate: String?
    var rateDouble: Double?
    
    var imagesFlag: UIImage? {
        guard let CharCode = CharCode else {
            return nil
        }
        return UIImage(named: CharCode + ".png")
    }
 
    class func rouble() -> Currency {
        let  r = Currency()
        r.CharCode = "BYR"
        r.Name = "Белорусский рубль"
        r.Scale = "1"
        r.scaleDouble = 1
        r.Rate = "1"
        r.rateDouble = 1
        
        return r
        
    }
    
}

class Model: NSObject, XMLParserDelegate   {
   static let shared = Model()
    
    var currencies: [Currency] = []
    var currentDate: String = ""
    
    
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
     func convert(amount: Double?) -> String {
        
        guard let amount = amount else {
            return ""
        }

       let d = ((fromCurrency.rateDouble! * fromCurrency.scaleDouble!) / (toCurrency.rateDouble! * toCurrency.scaleDouble!)) * amount
        
        let newD = Double(round(1000*d)/1000)
        return String(newD)
    }
    
    
    
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask
            , true)[0]+"/data.xml"
        print(path)
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        
        return   Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    var urlForXML: URL {
        return URL(fileURLWithPath: pathForXML)
    }
    
    // загрузка XML с НБРБ и сохранение в котологи преложения
    //http://www.nbrb.by/Services/XmlExRates.aspx?ondate=01/31/2011
    func loadXMLFile(date: Date?)  {
        
        var strUrl = "http://www.nbrb.by/Services/XmlExRates.aspx?ondate="
        
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            strUrl = strUrl + dateFormatter.string(from: date!)
        }
        
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            
            var errorGlobal: String?
            
            
            
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask
                    , true)[0]+"/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                
                do {
                   try data?.write(to: urlForSave)
                    print("Файл загружен")
                    self.parseXML()
                    
                } catch {
                    print("Error when save data:\(error.localizedDescription)")
                    errorGlobal = error.localizedDescription
                }
                
                
                
            } else {
                print("error when loadXMLFile:" + error!.localizedDescription)
                errorGlobal = error?.localizedDescription
            }
            
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name("ErrorWhenXMLLoading"), object: self, userInfo: ["ErrorName" : errorGlobal ])
            }
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
        
        task.resume()
    }
    
    // распарсить XML и положить его в currencies: [Currency], отправить уведомление приложению о том, что данные обновились
    func parseXML() {
        currencies = [Currency.rouble()]
        
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        
        print("Данные обновлены")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
        
        for c in currencies {
            if c.CharCode == fromCurrency.CharCode {
                fromCurrency = c
            }
            if c.CharCode == toCurrency.CharCode {
                toCurrency = c 
            }
        }
        
    }
    
    var currentCurrency: Currency?
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "DailyExRates" {
            if let currentDateString = attributeDict["Date"] {
           currentDate = currentDateString
                
            }
        }
      
        
        if elementName == "Currency" {
            currentCurrency = Currency()
        }
        
    }
    
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
        
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        /*
         
         <NumCode>036</NumCode>
         <CharCode>AUD</CharCode>
         <Scale>1</Scale>
         <Name>Австралийский доллар</Name>
         <Rate>2986.46</Rate>
         
         */
        if elementName == "NumCode" {
            currentCurrency?.NumCode = currentCharacters
        }
        if elementName == "CharCode" {
            currentCurrency?.CharCode = currentCharacters
        }
        if elementName == "Scale" {
            currentCurrency?.Scale = currentCharacters
            currentCurrency?.scaleDouble = Double(currentCharacters)
        }
        if elementName == "Name" {
            currentCurrency?.Name = currentCharacters
        }
        if elementName == "Rate" {
            currentCurrency?.Rate = currentCharacters
            currentCurrency?.rateDouble = Double(currentCharacters)
        }
        
        if elementName == "Currency" {
           currencies.append(currentCurrency!)
        }
    }
    
}
