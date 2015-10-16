//
//  RequestResult.swift
//  DotaApi
//
//  Created by lunner on 9/4/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation

class RequestResult {
	var statusCode: Int? = 0 // 200 success, 403 authentication_error, 503 timeout_error //http://www.ietf.org/rfc/rfc2616.txt
	var error: NSError?
	var resultData: NSData?
	
	func dataToArray() -> NSArray? {
		if resultData != nil {
			let jsonDict: NSDictionary?
			do {
				jsonDict = try NSJSONSerialization.JSONObjectWithData(resultData!, options: .MutableContainers) as? NSDictionary
			} catch {
				jsonDict = nil
				
				print("\(error)")
			}
			if jsonDict == nil {
				return nil
			}
			if jsonDict!["result"] != nil {
				return jsonDict!["result"] as? NSArray
			} else if jsonDict!["response"] != nil {
				return jsonDict!["response"] as? NSArray
			} else if jsonDict!["game"] != nil {
				return jsonDict!["game"] as? NSArray
			} else {
				return jsonDict as? NSArray
			}
		} 
		return nil

	}
	
	static func dataToArray(resultData: NSData?) -> NSArray? {
		if resultData == nil {
			return nil
		}
		let jsonDict: NSDictionary?
		do {
			jsonDict = try NSJSONSerialization.JSONObjectWithData(resultData!, options: .MutableContainers) as? NSDictionary
		} catch {
			jsonDict = nil
			
			print("\(error)")
		}
		if jsonDict == nil {
			return nil
		}
		if jsonDict!["result"] != nil {
			return jsonDict!["result"] as? NSArray
		} else if jsonDict!["response"] != nil {
			return jsonDict!["response"] as? NSArray
		} else if jsonDict!["game"] != nil {
			return jsonDict!["game"] as? NSArray
		} else {
			return jsonDict as? NSArray
		}
	}

	func dataToDictionary() -> NSDictionary? {
		if resultData != nil {
			let jsonDict = try? NSJSONSerialization.JSONObjectWithData(resultData!, options: .MutableContainers) as! NSDictionary
			if jsonDict == nil {
				print("JSONObjectWithData Error")
				return nil
			}
			if jsonDict!["result"] != nil {
				return jsonDict!["result"] as? NSDictionary
			} else if jsonDict!["response"] != nil {
				return jsonDict!["response"] as? NSDictionary
			} else if jsonDict!["game"] != nil {
				return jsonDict!["game"] as? NSDictionary
			} else {
				return jsonDict
			}
		} 
		return nil
		
	}
	
	static func dataToDictionary(resultData: NSData?) -> NSDictionary? {
		if resultData == nil {
			return nil
		}
		let jsonDict = try? NSJSONSerialization.JSONObjectWithData(resultData!, options: .MutableContainers) as! NSDictionary
		if jsonDict == nil {
			print("JSONObjectWithData Error")
			return nil
		}
		if jsonDict!["result"] != nil {
			return jsonDict!["result"] as? NSDictionary
		} else if jsonDict!["response"] != nil {
			return jsonDict!["response"] as? NSDictionary
		} else if jsonDict!["game"] != nil {
			return jsonDict!["game"] as? NSDictionary
		} else {
			return jsonDict
		}
		
	}

}