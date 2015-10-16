//
//  MatchItem.swift
//  DotaWatcher
//
//  Created by lunner on 10/10/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import Foundation
import UIKit
class MatchItem {
	var isDire = false
	var image: UIImage?
	var startTime: NSTimeInterval
	var lobbyType: LobbyType
	var matchID: String
	init(startTime: NSTimeInterval, lobbyType: LobbyType, heroImage image: UIImage?, isDire: Bool, matchID: String) {
		self.isDire = isDire
		self.startTime = startTime
		self.lobbyType = lobbyType
		self.image = image
		self.matchID = matchID
	}
}