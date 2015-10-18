//
//  Parse.swift
//  DotaApi
//
//  Created by lunner on 9/6/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreGraphics

class LUUtils: NSObject {
	
	static func applicationDocumentsDirectory() -> NSURL {
		let fileManager = NSFileManager.defaultManager()
		
		let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) 
		return urls[0]
	}
	
	static func convertTo64Bit(id: Int) -> Int64 {
		return Int64(id) + 76561197960265728
	}
	
	static func convertTo32Bit(id: Int64) -> Int32 {
		//return Int32(id - 76561197960265728)
		//return Int32(id)
		var count32: Int32 = 0
		for i in 0..<32 {
			if id.testBit(i) {
				count32.setBit(i)
			}
		}
		return count32
		//return Int32(id)
	}

	static func loadFromJSONFile(filename: String) -> NSDictionary? {
		let documentsURL = applicationDocumentsDirectory().URLByAppendingPathComponent("json", isDirectory: true)
		let storeURL = documentsURL.URLByAppendingPathComponent(filename)
		let inputStream = NSInputStream(URL: storeURL)
		defer {
			inputStream?.close()
		}

		inputStream?.open()
		let result = try? NSJSONSerialization.JSONObjectWithStream(inputStream!, options: .MutableContainers) as? NSDictionary

		return result!
	}
	static func saveToJSONFile(jsonDict: NSDictionary, filename: String) {
		let documentsURL = applicationDocumentsDirectory().URLByAppendingPathComponent("json", isDirectory: true)
		let storeURL = documentsURL.URLByAppendingPathComponent(filename)
		let outputStream = NSOutputStream(URL: storeURL, append: false)!
		defer {
			outputStream.close()
		}
		outputStream.open()
		var error: NSError?
		let num = NSJSONSerialization.writeJSONObject(jsonDict, toStream: outputStream, options: .PrettyPrinted, error: &error)
		if num == 0 {
			print("\(error?.localizedDescription)")
		}

	}
	
	static func getName(heroName: String) -> String {
		let name_ = heroName.componentsSeparatedByString("hero_").last!
		return name_.componentsSeparatedByString("_").joinWithSeparator(" ")
	}
	

	
	static func getHeroImageURLS(url: String) -> [String: String] {
		//let imagURLPrefix = "http://cdn.dota2.com/apps/dota2/images/heroes/"
		//"http://cdn.dota2.com/apps/dota2/images/heroes/lina_full.png?v=2952384?v=2952384"
		let imageURLBase = url.componentsSeparatedByString("?").first! 
		let surfix = imageURLBase.componentsSeparatedByString("/").last!.componentsSeparatedByString("_").last!
		let range = imageURLBase.rangeOfString(surfix)
		var imageFullURL = imageURLBase
		imageFullURL.replaceRange(range!, with: "full.png")
		var imageSmallURL = imageURLBase
		imageSmallURL.replaceRange(range!, with: "sb.png")
		var imageLargeURL = imageURLBase
		imageLargeURL.replaceRange(range!, with: "lg.png")
		var imageVertURL = imageURLBase
		imageVertURL.replaceRange(range!, with: "vert.jpg")
		var dict = [String: String]()
		dict["full"] = imageFullURL
		dict["sb"] = imageSmallURL
		dict["lg"] = imageLargeURL
		dict["vert"] = imageVertURL
		
		return dict
	}
	
	static func getHeroImageName(url: String) -> String {
		let imageName = url.componentsSeparatedByString("?").first!.componentsSeparatedByString("/").last!
		return imageName
	}
	
	static func getAbilityImageURLS(url: String) -> [String: String] {
		// let prefix = "http://cdn.dota2.com/apps/dota2/images/abilities/"
		//"http://cdn.dota2.com/apps/dota2/images/abilities/lina_laguna_blade_hp2.png?v=2952384"
		let imageURLBase = url.componentsSeparatedByString("?").first!
		let surfix = imageURLBase.componentsSeparatedByString("/").last!.componentsSeparatedByString("_").last!
		let range = imageURLBase.rangeOfString(surfix)!
		var hp1URL = imageURLBase
		hp1URL.replaceRange(range, with: "hp1.png")
		var hp2URL = imageURLBase
		hp2URL.replaceRange(range, with: "hp2.png")
		var dict = [String: String]()
		dict["hp1"] = hp1URL
		dict["hp2"] = hp2URL
		return dict
	}
	static func getAbilityImageName(url: String) -> String {
		return url.componentsSeparatedByString("?").first!.componentsSeparatedByString("/").last!
	}
	
	static func getItemImageURL(imageName: String) -> String {
		let imageURLPrefix = "http://cdn.dota2.com/apps/dota2/images/items/"
		return imageURLPrefix+imageName
	}
	
	static func getDateStringFromUnixTimeStamp(interval: NSTimeInterval) -> String {
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		let date = NSDate(timeIntervalSince1970: interval)
		return dateFormatter.stringFromDate(date)

	}
	
	static func getDayStringFromUnixTimeStamp(interval: NSTimeInterval) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let date = NSDate(timeIntervalSince1970: interval)
		return dateFormatter.stringFromDate(date)
	}
	static func getClockStringFromUnixTimeStamp(interval: NSTimeInterval) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm:SS"
		let date = NSDate(timeIntervalSince1970: interval)
		return dateFormatter.stringFromDate(date)
	}
	
	
}



// MARK: CGPoints extension
func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
	left = left + right
}

func - (left: CGPoint, right: CGPoint) ->CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (inout left: CGPoint, right: CGPoint) {
	left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (inout left: CGPoint, right: CGPoint) {
	left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
	return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (inout point: CGPoint, scalar: CGFloat) {
	point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (inout left: CGPoint, rihgt: CGPoint) {
	left = left / rihgt
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
	return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (inout point: CGPoint, scalar: CGFloat) {
	point = point/scalar
}

#if !(arch(x86_64) || arch(arm64))
	func atan2(y: CGFloat, x: CGFloat) ->CGFloat {
		return CGFloat(atan2f(Float(y), Float(x)))
	}
	
	func sqrt(a: CGFloat) -> CGFloat {
		return CGFloat(sqrtf(Float(a)))
	}
#endif

extension CGPoint {
	func lenght() -> CGFloat {
		return sqrt(x*x + y*y)
	}
	func normalized() -> CGPoint {
		return self / lenght()
	}
	var angle: CGFloat {
		return atan2(y, x)
	}
}


extension CGFloat {
	func sign() -> CGFloat {
		return (self >= 0.0) ? 1.0 : -1.0
	}
	static func random() -> CGFloat {
		return CGFloat(Float(arc4random()) / Float(UInt32.max))
	}
	static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
		assert(min < max)
		return CGFloat.random() * (max - min) + min
	}
}

extension Int8 {
	mutating func setBit(bit: Int) {
		self |= Int8(1 << bit)
	}
	
	mutating func clearBit(bit: Int) {
		self &= ~Int8(1 << bit)
	}
	
	func testBit(bit: Int) -> Bool {
		if self & Int8(1 << bit) == 0 {
			return false
		} else {
			return true
		}
	}
}
extension UInt8 {
	mutating func setBit(bit: Int) {
		self |= UInt8(1 << bit)
	}
	
	mutating func clearBit(bit: Int) {
		self &= ~UInt8(1 << bit)
	}
	
	func testBit(bit: Int) -> Bool {
		if self & UInt8(1 << bit) == 0 {
			return false
		} else {
			return true
		}
	}
}

extension UInt16 {
	mutating func setBit(bit: Int) {
		self |= UInt16(1 << bit)
	}
	
	mutating func clearBit(bit: Int) {
		self &= ~UInt16(1 << bit)
	}
	
	func testBit(bit: Int) -> Bool {
		if self & UInt16(1 << bit) == 0 {
			return false
		} else {
			return true
		}
	}

}

extension Int64 {
	mutating func setBit(bit: Int) {
		self |= Int64(1 << bit)
	}
	
	mutating func clearBit(bit: Int) {
		self &= ~Int64(1 << bit)
	}
	
	func testBit(bit: Int) -> Bool {
		if self & Int64(1 << bit) == 0 {
			return false
		} else {
			return true
		}
	}

}

extension Int32 {
	mutating func setBit(bit: Int) {
		self |= Int32(1 << bit)
	}
	
	mutating func clearBit(bit: Int) {
		self &= ~Int32(1 << bit)
	}
	
	func testBit(bit: Int) -> Bool {
		if self & Int32(1 << bit) == 0 {
			return false
		} else {
			return true
		}
	}
	
}


