//
//  DotaURLs.swift
//  DotaApi
//
//  Created by lunner on 9/4/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation

					

enum DotaURLs: String {
	case BaseURL = "https://api.steampowered.com/"
	// MARK: IDOTA2MATCH
	case GetMatchHistory = "IDOTA2Match_570/GetMatchHistory/v001/"
	case GetMatchHistoryBySeqNum = "IDOTA2Match_570/GetMatchHistoryBySequenceNum/v0001/"
	case GetMatchDetails = "IDOTA2Match_570/GetMatchDetails/v001/"
	case GetLeagueListing = "IDOTA2Match_570/GetLeagueListing/v0001/"
	case GetLiveLeagueGames = "IDOTA2Match_570/GetLiveLeagueGames/v0001/"
	case GetScheduledLeagueGames = "IDOTA2Match_570/GetScheduledLeagueGames/v001/"
	case GetTeamInfoByTeamID = "IDOTA2Match_570/GetTeamInfoByTeamID/v001/"
	case GetTournamentPlayerStats = "IDOTA2Match_570/GetTournamentPlayerStats/v001"
	
	// MARK: IDOTA2_<ID>
	case GetRarities = "IEconDOTA2_570/GetRarities/v001"
	case GetHeros = "IEconDOTA2_570/GetHeroes/v0001/"
	case GetTournamentPrizePool = "IEconDOTA2_570/GetTournamentPrizePool/v1/"
	case GetGameItems = "IEconDOTA2_570/GetGameItems/v0001/"
	case EconomySchema = "IEconItems_570/GetSchema/v0001/"
	
	// MARK: ISteamUser
	case GetFriendList = "ISteamUser/GetFriendList/v1"
	case GetPlayerBans = "ISteamUser/GetPlayerBans/v1"
	case GetUserGroupList = "ISteamUser/GetUserGroupList/v1"
	case GetPlayerSummaries = "ISteamUser/GetPlayerSummaries/v0002/"
	case ResolveVanityURL = "ISteamUser/ResolveVanityURL/v0001/"
	// MARK: 
}
enum CommonParams: String {
	case Key = "key"
	case Format = "format"
	case Language = "language"
}
enum GetMatchHistoryParams: String {
	// MARK:GetMatchHistory Parameters
	case HeroID = "hero_id"
	case GameMode = "game_mode"
	case Skill = "skill"
	case DateMax = "date_max"
	case DateMin = "date_min"
	case MinPlayers = "min_players"
	case AccountID = "account_id"
	case LeagueID = "league_id"
	case StartAtMatchID = "start_at_match_id"
	case MatchesRequested = "matches_requested"
	case TournamentGamesOnly = "tournament_games_only"
}

enum GetMatchHistoryResults: String {
	case Status = "status"
	case StatusDetail = "statusDetail"
	case NumResults = "num_results"
	case TotalResults = "total_results"
	case ResultsRemaining = "results_remaining"
	case Matches = "matches"
	case Matches_MatchID = "match_id"
	case Matches_MatchSeqNum = "match_seq_num"
	case Matches_StartTime = "start_time"
	case Matches_LobbyType = "lobby_type"
	case Matches_Players = "players"
	case Matches_Players_AccountID = "account_id"
	case Matches_Players_PlayerSlot = "player_slot"
	case Matches_Players_HeroID = "hero_id"
}

enum GetMatchHistoryBySeqNumParams: String {
	case StartAtMatchSeqNum = "start_at_match_seq_num"
	case MatchesRequested = "matches_requested"
}

enum GetMatchHistoryBySeqNumResults: String {
	case Status = "status"
	case StatusDetail = "statusDetail"
	case Matches = "matches"
	case Matches_Players = "players"
	case Matches_Players_AccountID = "account_id"
	case Matches_Players_PlayerSlot = "player_slot"
	case Matches_Players_HeroID = "hero_id"
	case Matches_Players_Item0 = "item_0"
	case Matches_Players_Item1 = "item_1"
	case Matches_Players_Item2 = "item_2"
	case Matches_Players_Item3 = "item_3"
	case Matches_Players_Item4 = "item_4"
	case Matches_Players_Item5 = "item_5"
	case Matches_Players_Kills = "kills"
	case Matches_Players_Deaths = "deaths"
	case Matches_Players_Assists = "assists"
	case Matches_Players_LeaverStatus = "leaver_status"
	case Matches_Players_Gold = "Matches_Players"
	case Matches_Players_LastHits = "last_hits"
	case Matches_Players_Denies = "denies"
	case Matches_Players_GoldPerMin = "gold_per_min"
	case Matches_Players_XpPerMin = "xp_per_min"
	case Matches_Players_GoldSpent = "gold_spent"
	case Matches_Players_HeroDamage = "hero_damage"
	case Matches_Players_TowerDamage = "tower_damage"
	case Matches_Players_HeroHealing = "hero_healing"
	case Matches_Players_Level = "level"
	case Matches_Season = "season"
	case Matches_RadiantWin = "radiant_win"
	case Matches_Duration = "duration"
	case Matches_StartTime = "start_time"
	case Matches_MatchID = "match_id"
	case Matches_MatchSeqNum = "match_seq_num"
	case Matches_TowerStatusRadiant = "tower_status_radiant"
	case Matches_TowerStatusDire = "tower_status_dire"
	case Matches_BarracksStatusRadiant = "barracks_status_radiant"
	case Matches_BarracksStatusDire = "barracks_status_dire"
	case Matches_cluster = "cluster"
	case Matches_FirstBloodTime = "first_blood_time"
	case Matches_LobbyType = "lobby_type"
	case Matches_HumanPlayers = "human_players"
	case Matches_LeagueID = "leagueid"
	case Matches_PositiveVotes = "positive_votes"
	case Matches_NegativeVotes = "negative_votes"
	case Matches_GameMode = "game_mode"
	case Matches_PicksBans = "picks_bans"
	case Matches_PicksBans_IsPick = "is_pick"
	
	case Matches_PicksBans_Team = "team" //0 for radiant, 1 for dire
	case Matches_PicksBans_Order = "order"
	
}

enum GetMatchHistoryBySeqNumResultsSecondary: String {
	case Matches_PicksBans_HeroID = "hero_id"
}

enum GetMatchDetailsParams: String {
	case MatchID = "match_id"
}

enum GetMatchDetailsResults: String {
	case Players = "players"
	case Players_AccountID = "account_id"
	case Players_PlayerSlot = "player_slot"
	case Players_HeroID = "hero_id"
	case Players_Item0 = "item_0"
	case Players_Item1 = "item_1"
	case Players_Item2 = "item_2"
	case Players_Item3 = "item_3"
	case Players_Item4 = "item_4"
	case Players_Item5 = "item_5"
	case Players_Kills = "kills"
	case Players_Deaths = "deaths"
	case Players_LeaverStatus = "leaver_status"
	case Players_Gold = "gold"
	case Players_LastHits = "last_hits"
	case Players_Denies = "denies"
	case Players_GoldPerMin = "GoldPerMin"
	case Players_XpPerMin = "xp_per_min"
	case Players_GoldSpent = "gold_spent"
	case Players_HeroDamage = "hero_damage"
	case Players_HeroHealing = "hero_healing"
	case Players_Level = "level"
	case Players_AbilityUpgrades = "ability_upgrades"
	case Players_AbilityUpgrades_Ability = "ability"
	case Players_AbilityUpgrades_Time = "time"
	case Players_AdditionalUnits = "additional_units"
	case Players_AdditionalUnits_UnitName = "unitname"
		
	case Season = "season"
	case RadiantWin = "radiant_win"
	case Duration = "duration"
	case StartTime = "start_time"
	case MatchID = "match_id"
	case MatchSeqNum = "match_seq_num"
	case TowerStatusRadiant = "tower_status_radiant"
	case TowerStatusDire = "tower_status_dire"
	case BarracksStatusRadiant = "barracks_status_radiant"
	case BarracksStatusDire = "barracks_status_dire"
	case Cluster = "cluster"
	case FirstBloodTime = "first_blood_time"
	case LobbyType = "lobby_type"
	case HumanPlayers = "human_players"
	case LeagueID = "leagueid"
	case PositiveVotes = "positive_votes"
	case NegativeVotes = "negative_votes"
	case GameMode = "game_mode"
	case PicksBans = "picks_bans"
	case PicksBans_IsPick = "is_pick"
	case PicksBans_Team = "team"
	case PicksBans_Order = "order"
	
}

enum GetMatchDetailsResultsSecondary: String {
	case Players_AbilityUpgrades_Level = "level"
	
	case Players_AdditionalUnits_Item0 = "item_0"
	case Players_AdditionalUnits_Item1 = "item_1"
	case Players_AdditionalUnits_Item2 = "item_2"
	case Players_AdditionalUnits_Item3 = "item_3"
	case Players_AdditionalUnits_Item4 = "item_4"
	case Players_AdditionalUnits_Item5 = "item_5"

	case PicksBans_HeroID = "hero_id"

}


enum GetMatchHistoryBySeqNumStatus: Int {
	case Success = 1
	case Fail = 8
}

typealias GetTeamInfoByTeamIDStatus = GetMatchHistoryBySeqNumStatus
typealias GetTournamentPlayerStatsStatus = GetMatchHistoryBySeqNumStatus

enum GetMatchHistoryStatus: Int {
	case Success = 1
	case Fail = 15
}
enum Skill: UInt32 {
	case Any = 0
	case Normal
	case High
	case VeryHigh
}
enum GetMatchHistoryGameMode: UInt32 {
	case None = 0
	case AllPick
	case CaptainsMode
	case RandomDraft
	case SignleDraft
	case AllRandom
	case Intro
	case Diretide
	case ReverseCaptainsMode
	case TheGreeviling
	case Tutorial
	case MidOnly
	case LeastPlayed
	case NewPlayerPool
	case CompendiumMatchmaking
	case CaptainsDraft
}

typealias GetMatchDetailsGameMode = GetMatchHistoryGameMode

enum GetMatchHistoryBySeqNumGameMode: UInt32 {
	case AllPick = 0
	case SingleDraft
	case AllRandom
	case RandomDraft
	case CaptainsDraft
	case CaptainsMode
	case DeathMode
	case Diretide
	case ReverseCaptainsMode
	case TheGreeviling
	case Tutorial
	case MidOnly
	case LeastPlayed
	case NewPlayerPool
}


enum LobbyType: Int {
	case Invalid = -1
	case PublicMatchMaking = 0
	case Practise
	case Tournament
	case Tutorial
	case Co_opWithBots
	case TeamMatch
	case SoloQueue
	case RankedMatchMaking
	case OnevVOneSoloMid	
}

enum GetLeagueListingParams: String {
	case Language = "language"
}

enum GetLeagueListingResults: String {
	case Leagues = "leagues"
	case Leagues_Name = "name"
	case Leagues_leagueid = "leagueid"
	case Leagues_description = "description"
	case Leagues_TournamentURL = "tournament_url"
}

enum GetLiveLeagueGames: String {
	case Games = "games"
	case Games_Players = "players"
	case Games_Players_AccountID = "account_id"
	case Games_Players_HeroID = "hero_id"
	case Games_Players_Team = "team"
	case Games_RadiantTeam = "RadiantTeam"
	case Games_RadiantTeam_TeamName = "team_name"
	case Games_RadiantTeam_TeamID = "team_id"
	case Games_RadiantTeam_TeamLogo = "team_logo" //The UGC id for the team logo. You can resolve this with the GetUGCFileDetails method.
	case Games_RadiantTeam_Complete = "complete"
	case Games_DireTeam = "dire_team"
	case Games_LobbyID = "LobbyID"
	case Games_Spectators = "spectators"
	case Games_TowerState = "tower_state"
	case Games_LeagueID = "league_id"
}

enum GetLiveLeagueGamesSecondary: String {
	case Games_DireTeam_TeamName = "team_name"
	case Games_DireTeam_TeamID = "team_id"
	case Games_DireTeam_TeamLogo = "team_logo"
	case Games_DireTeam_Complete = "complete"
}

enum GetScheduledLeagueGamesParams: String {
	case DateMin = "date_min"//uint32
	case DataMax = "date_max"
}

enum GetScheduledLeagueGamesResults: String {
	case LeagueID = "league_id"
	case GameID = "game_id"
	case Teams = "teams"
	case Teams_TeamID = "team_id"
	case Teams_TeamName = "team_name"
	case Teams_TeamLogo = "team_logo"
	case StartTime = "starttime"
	case Comment = "comment"
	case Final = "final"
}

enum GetTeamInfoByTeamIDParams: String {
	case StartAtTeamID = "start_at_team_id"
	case TeamsRequested = "teams_requested"
}

enum GetTeamInfoByTeamIDResults: String {
	case Status = "status"
	case StatusDetail = "statusDetail"
	case Teams = "teams"
	case Teams_TeamID = "team_id"
	case Teams_Name = "name"
	case Teams_Tag = "tag"
	case Teams_TimeCreated = "time_created"
	case Teams_Rating = "rating"
	case Teams_Logo = "logo"
	case Teams_LogoSponsor = "logo_sponsor"
	case Teams_CountryCode = "country_code"
	case Teams_URL = "url"
	case Teams_GamesPlayedWithCurrentRoster = "games_played_with_current_roster"
	case Teams_PlayersNAccountID = "player_N_account_id"// N 0...count-1
	case Teams_AdminAccountID = "admin_account_id"
}

enum GetTournamentPlayerStatsParams: String {
	case AccountID = "account_id"
	case LeagueID = "league_id"
	case HeroID = "hero_id"
	case TimeFrame = "time_frame"
	
}

enum GetTournamentPlayerStatsResults: String {
	case Status = "status"
	case StatusDetail = "statusDetail"
	case NumResults = "num_results"
	case Matches = "matches"
	case Matches_PlayerSlot = "player_slot"
	case Matches_HeroID = "hero_id"
	case Matches_Item0 = "item_0"
	case Matches_Item1 = "item_1"
	case Matches_Item2 = "item_2"
	case Matches_Item3 = "item_3"
	case Matches_Item4 = "item_4"
	case Matches_Item5 = "item_5"
	case Matches_Kills = "kills"
	case Matches_Deaths = "deaths"
	case Matches_Assists = "assists"
	case Matches_Gold = "gold"
	case Matches_LastHits = "last_hits"
	case Matches_Denies = "denies"
	case Matches_GoldPerMin = "gold_per_min"
	case Matches_XpPerMin = "xp_per_min"
	case Matches_GoldSpent = "gold_spent"
	case Matches_Level = "level"
	case Matches_Win = "win"
	case Matches_MatchID = "match_id"
	case Matches_Duration = "duration"
	case AccountID = "account_id"
	case Persona = "persona"	//Account's current Steam profile name
	case Wins = "wins"
	case Losses = "losses"
	case Kills = "Kills"
	case KillsAverage = "kills_average"
	case AssistsAverage = "assists_average"
	case GPMAverage = "gpm_average"
	case BestKills = "best_kills"
	case BestKillsHeroID = "best_kills_heroid"
	case BestGPM = "best_gpm"
	case BestGPMHeroID = "best_gpm_heroid"
	case HerosPlayed = "heros_played"
	case HerosPlayed_ID = "id"
}

enum GetTournamentPlayerStatsResultsSecondary: String {
	case Deaths = "deaths"
	case Assists = "assists"
	case HerosPlayed_Wins = "wins"
	case HerosPlayed_Losses = "losses"

}

enum GetHeroesParams: String {
	case Language = "language"
	case ItemizedOnly = "itemizedonly"
}

enum GetHerosResult: String {
	case Heroes = "Heroes"
	case Heroes_Name = "name"
	case Heroes_ID = "id"
	case Heroes_LocalizedName = "localized_name"
	case Count = "count"
}

enum GetRaritiesParams: String {
	case Language = "language"
}

enum GetRaritiesResults: String {
	case Count = "count"
	case Rarities = "rarities"
	case Rarities_Name = "name"
	case Rarities_ID = "id"
	case Rarities_Order = "order"
	case Rarities_Color = "color"
	case Rarities_LocalizedName = "localized_name"
}

enum GetTournamentPrizePoolParams: String {
	case LeagueID = "leagueid"
}

enum GetTournamentPrizePoolResults: String {
	case PrizePool = "prize_pool"
	case LeagueID = "league_id"
}


enum GetGameItemsParams: String {
	case Language = "language"
}

enum GetGameItemsResults: String {
	case Items = "items"
	case Items_ID = "id"
	case Items_Name = "name"
	case Items_Cost = "cost"
	case Items_SecretShop = "secret_shop" //1 0
	case Items_SideShop = "side_shop" //1 0
	case Items_Recip = "recip" //1 0
	case Items_LocalizedName = "localized_name"
}

/*
enum GetSchemaParams: String {
	case Language = "language"
	
}
enum Qualities: Int {
	case Normal = 0
	case Rarity1 = 1
	case Rarity2 
	case Vintage
	case Rarity3
	case Rarity4
	case Unique
	case Community
	case Developer
	case Selfmade
	case Customized
	case Strange
	case Completed
	case Haunted
	case Collectors
}
enum ItemSlot: String {
	case Primary = "primary"
	case Secondary = "secondary"
	case Melee = "melee"
	case Head = "head"
	case Misc = "misc"
	case Pda = "pda"
	case Pda2 = "pda2"
	case Building = "building"
	case Grenade = "grenade"
	case Action = "action"
}
enum DropType: String {
	case None = "none"
	case Drop = "drop"
}
enum DescriptionFormat: String {
	case ValueIsPercentage = "value_is_percentage"
	case ValueIsInvertedPercentage = "value_is_inverted_percentage"
	case ValueIsAdditive = "value_is_additive"
	case ValueIsAdditivePercentage = "value_is_additive_percentage"
	case ValueIsDate = "value_is_date"
	case ValueIsParticleIndex = "value_is_particle_index"
	case ValueIsAccountID = "value_is_account_id"
	case ValueIsOr = "value_is_or"
	case ValueIsItemDef = "value_is_item_def"
}
enum EffectType: String {
	case Positive = "positive"
	case Negative = "negative"
	case Neutral = "neutral"
}
struct OriginNames {
	static let Oneself = "originNames"
	static let Origin = "origin"
	static let Name = "name"
}
enum GetSchemaResults: String {
	case Status = "status"	//should always be 1
	case ItemsGameURL = "items_game_url"
	case Qualities = "qualities"
 	case QualityNames = "qualityNames"
	case OriginNames = "originNames"
	case OriginNames_Origin = "origin"

	case Items = "items"
	case Items_Defindex = "defindex"
	case Items_ItemClass = "item_class"
	case Items_ItemTypeName = "item_type_name"
	case Items_ItemName = "item_name"
	case Items_ItemDescription = "item_description"
	case Items_ProperName = "proper_name"
	case Items_ItemSlot = "item_slot"
	case Items_ItemQuality = "item_quality"
	case Items_ImageInventory = "image_inventory"
	case Items_ImageURL = "image_url"
	case Items_ImageURLLage = "image_url_large"
	case Items_DropType = "drop_type"
	case Items_ItemSet = "item_set"
	case Items_HolidayRestriction = "holiday_restriction" //halloween
	case Items_ModelPlayer = "model_player"
	case Items_MinILevel = "min_ilevel"
	case Items_MaxILevel = "max_ilevel"
	case Items_CraftClass = "craft_class"
	case Items_CraftMaterialType = "craft_material_type"
	case Items_Capabilities = "capabilities"
	case Items_Capabilities_CanCraftMark = "can_craft_mark"
	case Items_Capabilities_Nameable = "nameable"
	case Items_Capabilities_CanGiftWrap = "can_gift_wrap"
	case Items_Capabilities_Paintable = "paintable"
	case Items_Capabilities_CanCraftCount = "can_craft_count"
	case Items_Capabilities_Decodable = "decodable"
	case Items_Capabilities_Usable = "usable"
	case Items_Capabilities_UsableGc = "usable_gc"
	case Items_Capabilities_UsableOutOfGame = "usable_out_of_game"
	case Items_Tool = "tool"
	case Items_UsedByClasses = "used_by_classes"
	case Items_Styles = "styles"

	case Items_Attributes = "attributes"

	case Items_Attributes_Class = "class"
	case Items_Attributes_Value = "value"

	case Attributes_Name = "name"

	case Attributes_AttributeClass = "attribute_class"
	case Attributes_Minvalue = "minvalue"
	case Attributes_Maxvalue = "maxvalue"
	case Attributes_DescriptionString = "description_string"
	case Attributes_DescriptionFormat = "description_format"
	case Attributes_EffectType = "effect_type"
	case Attributes_Hidden = "hidden"
	case Attributes_StoredAsInteger = "store_as_integer"
	case ItemSets = "item_sets"
	case ItemSets_StoreBundle = "store_bundle"
	case AttributeControlledAttachedParticles = "attribute_controlled_attached_particles"
	case AttributeControlledAttachedParticles_System = "system"
	case AttributeControlledAttachedParticles_ID = "id"
	case AttributeControlledAttachedParticles_AttachToRootbone = "attach_to_rootbone"
	case AttributeControlledAttachedParticles_Attachment = "attachment"
	case ItemLevels = "item_levels"

	case ItemLevels_Levels = "levels"
	case ItemLevels_Levels_Level = "level"
	case ItemLevels_Levels_RequiredScore = "required_score"

	case KillEaterScoreTypes = "kill_eater_score_types"
	case KillEaterScoreTypes_Type = "type"
	case KillEaterScoreTypes_TypeName = "type_name"
	
}
let OriginNames_Name = "name"
let ItemsStyles_Name = "name"
let ItemLevels_Levels_Name = "name"
let Items_Attributes_Name = "name"
let ItemLevels_Name = "name"
let AttributeControlledAttachedParticles_Name = "name"
let ItemSets_Attributes = "attributes"
let ItemSets_Name = "name"



enum GetSchemaResultsSecondary: String {
	case Items_Name = "name"
	case Items_PerClassLoadoutSlots = "used_by_classes"
	case Attributes = "attributes"
	case ItemSets_Items = "items"
	case ItemSets_ItemSet = "item_set"
	case Attributes_Defindex = "defindex"
}*/


