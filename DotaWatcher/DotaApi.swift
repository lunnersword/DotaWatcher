//
//  DotaApi.swift
//  DotaApi
//
//  Created by lunner on 9/4/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation

class DotaApi {
	var apiKey: String = "7CFACD5BD037C2FCD0D4DE5EE1BBD877"
	var language: String
	var format: String 
	
	init() {
		self.language = "en_US"
		self.format = "json"
	}
	
	init(apiKey: String, language: String? = nil, format: String? = nil) {
		self.apiKey = apiKey 
		if language == nil {
			self.language = "zh_CN"
		} else {
			self.language = language!
		}
		if format == nil {
			self.format = "json"
		} else {
			let xml = "xml"
			let json = "json"
			let vdf = "vdf"
			if !(format! as NSString).isEqualToString(xml) && !(format! as NSString).isEqualToString(json) && !(format! as NSString).isEqualToString(vdf) {
				self.format = "json"
			} else {
				self.format = format!
			}
		}
	}
	// MARK: Dota 2
	func getMatchHistory(accountID: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if accountID != nil {
			kwargs["account_id"] = accountID
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetMatchHistory.rawValue), params: kwargs)
		
		if result.statusCode != 200 {
			return nil
		} else {
			return result
		}
		
	}
	
	func getMatchHistoryAsync(accountID: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void)) {
		if accountID != nil {
			kwargs["account_id"] = accountID
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetMatchHistory.rawValue), params: kwargs, completionHandler: completionHandler)
	}
	
	func getMatchHistoryBySeqNum(seqNum: String? = nil, matchesRequested: UInt32? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if seqNum != nil {
			kwargs["start_at_match_seq_num"] = seqNum
		}
		if matchesRequested != nil {
			kwargs["matches_requested"] = matchesRequested!.description
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetMatchHistoryBySeqNum.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil
		} else {
			return result
		}
	}
	
	func getMatchHistoryBySeqNumAsync(seqNum: String? = nil, matchesRequested: UInt32? = nil, var kwargs: [String: String] = [String: String](),  completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		if seqNum != nil {
			kwargs["start_at_match_seq_num"] = seqNum
		}
		if matchesRequested != nil {
			kwargs["matches_requested"] = matchesRequested!.description
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetMatchHistoryBySeqNum.rawValue), params: kwargs, completionHandler: completionHandler)
	}
	
	func getMatchDetails(matchID: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if matchID != nil {
			kwargs["match_id"] = matchID
		}
		if kwargs["match_id"] == nil {
			return nil
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetMatchDetails.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil
		} else {
			return result
		}
		
	}
	func getMatchDetailsAsync(matchID: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) )  {
		if matchID != nil {
			kwargs["match_id"] = matchID
		}
		if kwargs["match_id"] == nil {
			completionHandler(nil, nil, NSError(domain: "LUNNER", code: 1, userInfo: nil) )
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetMatchDetails.rawValue), params: kwargs, completionHandler: completionHandler)
		
	}
	
	
	func getLeagueListing(language: String? = nil, var kwargs: [String: String] = [String:String]()) -> RequestResult? {
		if language != nil {
			kwargs["language"] = language
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetLeagueListing.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
	}
	
	func getLeagueListingAsync(language: String? = nil, var kwargs: [String: String] = [String:String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) )  {
		if language != nil {
			kwargs["language"] = language
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetLeagueListing.rawValue), params: kwargs, completionHandler: completionHandler)
		
	}
	
	
	func getLiveLeagueGames(var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetLiveLeagueGames.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
		
	}
	
	func getLiveLeagueGamesAsync(var kwargs: [String: String] = [String: String](),  completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetLiveLeagueGames.rawValue), params: kwargs, completionHandler: completionHandler)		
	}
	
	func getTeamInfoByTeamID(startAtTeamID: String? = nil, teamsRequested: UInt32? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if startAtTeamID != nil {
			kwargs["start_at_team_id"] = startAtTeamID
		}
		if teamsRequested != nil {
			kwargs["teams_requested"] = teamsRequested!.description
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetTeamInfoByTeamID.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
		
	}
	
	func getTeamInfoByTeamIDAsync(startAtTeamID: String? = nil, teamsRequested: UInt32? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		if startAtTeamID != nil {
			kwargs["start_at_team_id"] = startAtTeamID
		}
		if teamsRequested != nil {
			kwargs["teams_requested"] = teamsRequested!.description
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetTeamInfoByTeamID.rawValue), params: kwargs, completionHandler: completionHandler)		
	}
	
	func getScheduledLeagueGames(dateMin: UInt32? = nil, dateMax: UInt32? = nil,var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		//var kwargs: [String: String] = [String: String]()
		if dateMin != nil {
			kwargs["date_min"] = dateMin!.description
		} 
		if dateMax != nil {
			kwargs["date_max"] = dateMax!.description
		}
		
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetScheduledLeagueGames.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
	}
	
	func getScheduledLeagueGamesAsync(dateMin: UInt32? = nil, dateMax: UInt32? = nil,var kwargs: [String: String] = [String: String](),  completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		//var kwargs: [String: String] = [String: String]()
		if dateMin != nil {
			kwargs["date_min"] = dateMin!.description
		} 
		if dateMax != nil {
			kwargs["date_max"] = dateMax!.description
		}
		
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetScheduledLeagueGames.rawValue), params: kwargs, completionHandler: completionHandler)
		
	}
	
	
	func getTournamentPlayerStats(accountID: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if accountID != nil {
			kwargs["account_id"] = accountID
		}
		if kwargs["account_id"] == nil {
			return nil
		}
		
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetTournamentPlayerStats.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
		
	}
	
	func getTournamentPlayerStatsAsync(accountID: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		if accountID != nil {
			kwargs["account_id"] = accountID
		}
		if kwargs["account_id"] == nil {
			completionHandler(nil, nil, NSError(domain: "LUNNER", code: 1, userInfo: nil))
		}
		
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetTournamentPlayerStats.rawValue), params: kwargs, completionHandler: completionHandler)
		
	}
	
	
	// MARK: ISteamUser
	func getFriendList(steamID: String? = nil, relationShip: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if steamID != nil {
			kwargs["steamid"] = steamID
		}
		if relationShip != nil {
			kwargs["relationship"] = relationShip
		}
		if kwargs["steamid"] == nil {
			return nil
		}
		if kwargs["relationship"] == nil {
			kwargs["relationship"] = "friend"
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetFriendList.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
	}
	
	func getFriendListAsync(steamID: String? = nil, relationShip: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		if steamID != nil {
			kwargs["steamid"] = steamID
		}
		if relationShip != nil {
			kwargs["relationship"] = relationShip
		}
		if kwargs["steamid"] == nil {
			completionHandler(nil, nil ,NSError(domain: "LUNNER", code: 0, userInfo: nil))
		}
		if kwargs["relationship"] == nil {
			kwargs["relationship"] = "friend"
		}
		adjustQuearyParams(params: &kwargs)
		
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetFriendList.rawValue), params: kwargs, completionHandler: completionHandler)
		
	}
	
	
	func getPlayerBans(steamIDs: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		//Comma-delimited list of SteamIDs
		if steamIDs != nil {
			kwargs["steamids"] = steamIDs
		}
		if kwargs["steamids"] == nil {
			return nil
		}
		
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetPlayerBans.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
		
	}
	
	func getPlayerBansAsync(steamIDs: String? = nil, var kwargs: [String: String] = [String: String](),  completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void)) {
		//Comma-delimited list of SteamIDs
		if steamIDs != nil {
			kwargs["steamids"] = steamIDs
		}
		if kwargs["steamids"] == nil {
			completionHandler(nil, nil, NSError(domain: "LUNNER", code: 0, userInfo: nil))	
		}
		
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetPlayerBans.rawValue), params: kwargs, completionHandler: completionHandler)
		
		
	}
	
	
	func getPlayerSummaries(steamIDs: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		//Comma-delimited list of SteamIDs
		if steamIDs != nil {
			kwargs["steamids"] = steamIDs
		}
		if kwargs["steamids"] == nil {
			return nil
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetPlayerSummaries.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
		
	}
	
	func getPlayerSummariesAsync(steamIDs: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		//Comma-delimited list of SteamIDs
		if steamIDs != nil {
			kwargs["steamids"] = steamIDs
		}
		if kwargs["steamids"] == nil {
			completionHandler(nil, nil, NSError(domain: "LUNNER", code: 0, userInfo: nil))
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetPlayerSummaries.rawValue), params: kwargs, completionHandler: completionHandler)		
	}
	
	
	func getUserGroupList(steamID: String? = nil, var kwargs: [String: String] = [String: String]() ) -> RequestResult? {
		if steamID != nil {
			kwargs["steamid"] = steamID
		}
		if kwargs["steamid"] == nil {
			return nil
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetUserGroupList.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
		
	}
	func getUserGroupListAsync(steamID: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) )  {
		if steamID != nil {
			kwargs["steamid"] = steamID
		}
		if kwargs["steamid"] == nil {
			completionHandler(nil, nil, NSError(domain: "LUNNER", code: 0, userInfo: nil))
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetUserGroupList.rawValue), params: kwargs, completionHandler: completionHandler)
		
	}
	
	func resolveVanityURL(vanityURL: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if vanityURL != nil {
			kwargs["vanityurl"] = vanityURL
		}
		if kwargs["vanityurl"] == nil {
			return nil
		}
		kwargs["key"] = self.apiKey
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.ResolveVanityURL.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
		
	}
	
	func resolveVanityURLAsync(vanityURL: String? = nil, var kwargs: [String: String] = [String: String](),  completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void))  {
		if vanityURL != nil {
			kwargs["vanityurl"] = vanityURL
		}
		if kwargs["vanityurl"] == nil {
			completionHandler(nil, nil, NSError(domain: "LUNNER", code: 2, userInfo: nil))
		}
		kwargs["key"] = self.apiKey
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.ResolveVanityURL.rawValue), params: kwargs, completionHandler: completionHandler)
		
	}
	//End ISteamUser
	
	// MARK: IDOTA2_<ID>
	func getRarities(var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetRarities.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
	}
	
	func getRaritiesAsync(var kwargs: [String: String] = [String: String](),   completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) )  {
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet( String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetRarities.rawValue), params: kwargs, completionHandler: completionHandler)
	}
	
	func getHeroes(language: String? = nil, itemizedOnly: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if language != nil {
			kwargs["language"] = language
		}
		if itemizedOnly != nil {
			kwargs["itemizedonly"] = itemizedOnly
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetHeros.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
	}
	
	func getHeroesAsync(language: String? = nil, itemizedOnly: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		if language != nil {
			kwargs["language"] = language
		}
		if itemizedOnly != nil {
			kwargs["itemizedonly"] = itemizedOnly
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet( String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetHeros.rawValue), params: kwargs, completionHandler: completionHandler)
	}
	
	
	func getGameItems(language: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if language != nil {
			kwargs["language"] = language
		}
		adjustQuearyParams(params: &kwargs)
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetGameItems.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
	}
	
	func getGameItemsAsync(language: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) )  {
		if language != nil {
			kwargs["language"] = language
		}
		adjustQuearyParams(params: &kwargs)
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetGameItems.rawValue), params: kwargs, completionHandler: completionHandler)
		
	}
	
	
	func getTournamentPrizePool(leagueID: String? = nil, var kwargs: [String: String] = [String: String]()) -> RequestResult? {
		if leagueID != nil {
			kwargs["leagueid"] = leagueID
		}
		let result = Request.get(url: String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetTournamentPrizePool.rawValue), params: kwargs)
		if result.statusCode != 200 {
			return nil 
		} else {
			return result
		}
	}
	
	func getTournamentPrizePoolAsync(leagueID: String? = nil, var kwargs: [String: String] = [String: String](), completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void) ) {
		if leagueID != nil {
			kwargs["leagueid"] = leagueID
		}
		Request.queuedGet(String(format: "%@%@", DotaURLs.BaseURL.rawValue, DotaURLs.GetTournamentPrizePool.rawValue), params: kwargs, completionHandler: completionHandler)
	}
	
	// End IDOTA2_<ID>
	// MARK: update items and heros, test fails
	
	func updateGameItems(language: String? = nil) {
		let result = getGameItems(language)
		if result == nil {
			return
		}
		var filename: String
		if language != nil {
			filename = "items_\(language).json"
		} else {
			filename = "items_\(language).json"
		}
		LUUtils.saveToJSONFile(result!.dataToDictionary()!, filename: filename)
	}
	
	
	
	func loadGameItems(language: String? = nil) -> NSDictionary? {
		var filename: String
		if language != nil {
			filename = "items_\(language).json"
		} else {
			filename = "items_\(language).json"
		}
		return LUUtils.loadFromJSONFile(filename)
	}
	
	func updateHeros(language: String? = nil) {
		let result = getHeroes(language)
		if result == nil {
			return
		}
		var filename: String
		if language != nil {
			filename = "heros_\(language).json"
		} else {
			filename = "heros_\(self.language).json"
		}
		LUUtils.saveToJSONFile(result!.dataToDictionary()!, filename: filename)
	}
	
	func loadHeros(language: String? = nil) -> NSDictionary? {
		var filename: String
		if language != nil {
			filename = "heros_\(language).json"
		} else {
			filename = "heros_\(self.language).json"
		}
		return LUUtils.loadFromJSONFile(filename)
		
	}
	
	
	func adjustQuearyParams(inout params params: [String: String])  {
		params[CommonParams.Key.rawValue] = self.apiKey
		if params[CommonParams.Language.rawValue] == nil {
			params[CommonParams.Language.rawValue] = self.language
		}
		if params[CommonParams.Format.rawValue] == nil {
			params[CommonParams.Format.rawValue] = self.format
		}
		
	}
	
	
	
}