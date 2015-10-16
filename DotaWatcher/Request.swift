//
//  Request.swift
//  DotaApi
//
//  Created by lunner on 9/4/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation

class Request {
	static var queue: NSOperationQueue? 
	
	static func get(url url: String, params: [String: String]?) -> RequestResult {
		let paramString: NSMutableString = NSMutableString(string: "?")
		//let keys = params.allKeys
//		for(var key in keys) {
		if let params = params {
			for (key, value) in params {
				paramString.appendFormat("%@=%@&", key, value)
			}

		}
		let requestURL = "\(url)\(paramString.substringToIndex(paramString.length-1))"
		
		let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: requestURL)!, cachePolicy:  NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
		request.HTTPMethod = "GET"
		
		var response: NSURLResponse?
		let result = RequestResult()
		let resp = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
		let httpResponse = response as? NSHTTPURLResponse
		result.statusCode = httpResponse?.statusCode
		result.resultData = resp
		return result
	}
	
	static func queuedGet(url: String, params: [String: String]?, completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void))  {
		let paramString: NSMutableString = NSMutableString(string: "?")
		//let keys = params.allKeys
		//		for(var key in keys) {
		if let params = params {
			for (key, value) in params {
				paramString.appendFormat("%@=%@&", key, value)
			}
			
		}
		let requestURL = "\(url)\(paramString.substringToIndex(paramString.length-1))"
		let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: requestURL)!, cachePolicy:  NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
		request.HTTPMethod = "GET"
		
		if self.queue == nil {
			queue = NSOperationQueue()
		}
		
		NSURLConnection.sendAsynchronousRequest(request, queue: queue!, completionHandler: completionHandler)
	}
		
		
		
		
}