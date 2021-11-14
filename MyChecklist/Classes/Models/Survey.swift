//
//  Survey.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import Foundation

struct Survey: Codable {
    var gender: Gender
    var age: Int = 18
    var height: Int = 170
    var weight: Int = 70
    var smoke: Smoke?
    var alcohol: Alcohol?
    var bloodPressureTop: Int?
    var bloodPressureLow: Int?
    var bpUndefined = false
    var hasHighCholesterol = false // high cholesterol
    var hasDiabetes  = false // diabetes
    var hasBrokenBone = false // brokeBone
    var hasFamilyInfarct = false // Stroke
    var hasFamilyInsult = false // insult
    var hasFamilyRelativeHipBroke = false // relativeHipBroke
    var hasFamilyDiabetis = false // familyDiabetis
    var hasChronicLungs = false // chronicLungs
    var hasChronicHeart = false // chronicHeart
    var hasChronicLiver = false // chronicLiver
    var hasChronicStomach = false // chronicStomach
    var hasChronicKidneys = false // chronicKidneys
    var hasHiv = false // Hiv
    var hasProstateCancer = false // prostateCancer
    var hasCervicalCancerWoman = false // cervicalCancerWoman
    var hasColonCancer = false // colonCancer + gender
    var hasStomachCancer = false // stomachCancer + gender
    var hasLungsCancer = false // lungsCancer + gender
    var hasMelanoma = false // melanoma + gender
    
    var prostateDetails: ProstateCancerDetails? // prostateCancerDetails
    var stomachDetails: StomachCancerDetails? // stomachCancerDetails
    var colonDetails: ColonCancerDetails? // colonCancerDetails
    
//    enum CodingKeys: String, CodingKey {
//        case gender, age, height
//        case weight, smoke, alcohol
//        case bloodPressure
//        case bpUndefined = "bp-undefined"
//        case highCholesterol = "high cholesterol"
//    }
}

enum Gender: String, Codable {
    case man
    case woman
}

enum Smoke: String, Codable {
    case smokingNow
    case quitSmoking
    case noSmoking
}

enum Alcohol: String, Codable {
    case heavyDrinker
    case lightDrinker
    case noDrinker
}

struct BloodPressure: Codable {
    var bloodPressureTop: Int = 120
    var bloodPressureLow: Int = 80
}

enum ProstateCancerDetails: Codable {
    case morethan1
    case under65
    case over65
}

enum StomachCancerDetails: Codable {
    case morethan3
    case under40
    case under50
    case complex
    case none
}

enum ColonCancerDetails: Codable {
    case lessthan60
    case manyRelatives
    case over60
    case manyCousins
}
