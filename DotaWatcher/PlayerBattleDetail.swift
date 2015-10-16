//
//  PlayerBattleDetail.swift
//  DotaWatcher
//
//  Created by lunner on 10/12/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import Foundation

class PlayerBattleDetail {
	var accountID: Int!
	var playerSlot: UInt8!
	var heroID: Int!
	var items: [Int]!
	var kills: Int!
	var deaths: Int! 
	var assists: Int!

	var gold: Int!
	var lastHits: Int!
	var denies: Int!
	var goldPerMin: Int!
	var xpPerMin: Int!
	var goldSpent: Int!
	var heroDamage: Int!
	var towerDamage: Int!
	var heroHealing: Int!
	var level: Int!
	
	var abilityUpgrades: [[String: Int]]!
	//var additionalUnits: [[String: Int]]!
	
}