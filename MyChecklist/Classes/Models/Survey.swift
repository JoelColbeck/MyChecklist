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
    var bloodPressureTop: Int = 140
    var bloodPressureLow: Int = 90
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
    var hasColonCancerMan = false // colonCancerMan
    var hasColonCancerWoman = false // colonCancerWoman
    var hasStomachCancerMan = false // stomachCancerMan
    var hasStomachCancerWoman = false // stomachCancerWoman
    var hasLungsCancerMan = false // lungsCancerMan
    var hasLungsCancerWoman = false // lungsCancerWoman
    var hasMelanomaMan = false // melanomaMan
    var hasMelanomaWoman = false // melanomaWoman
    
    var prostateCancerDetails: ProstateCancerDetails? // prostateCancerDetails
    var stomachCancerDetails: StomachCancerDetails? // stomachCancerDetails
    var colonCancerDetails: ColonCancerDetails? // colonCancerDetails
    
    enum CodingKeys: String, CodingKey {
        case gender, age, height, weight
        case smoke, alcohol
        case bloodPressureTop, bloodPressureLow
        case prostateCancerDetails, stomachCancerDetails, colonCancerDetails
        case bpUndefined = "bp-undefined"
        case hasHighCholesterol = "high cholesterol"
        case hasDiabetes = "diabetes"
        case hasBrokenBone = "brokeBone"
        case hasFamilyInfarct = "Stroke"
        case hasFamilyInsult = "insult"
        case hasFamilyRelativeHipBroke = "relativeHipBroke"
        case hasFamilyDiabetis = "familyDiabetis"
        case hasChronicLungs = "chronicLungs"
        case hasChronicHeart = "chronicHeart"
        case hasChronicLiver = "chronicLiver"
        case hasChronicStomach = "chronicStomach"
        case hasChronicKidneys = "chronicKidneys"
        case hasHiv = "Hiv"
        case hasProstateCancer = "prostateCancer"
        case hasCervicalCancerWoman = "cervicalCancerWoman"
        case hasColonCancerMan = "colonCancerMan"
        case hasColonCancerWoman = "colonCancerWoman"
        case hasStomachCancerMan = "stomachCancerMan"
        case hasStomachCancerWoman = "stomachCancerWoman"
        case hasLungsCancerMan = "lungsCancerMan"
        case hasLungsCancerWoman = "lungsCancerWoman"
        case hasMelanomaMan = "melanomaMan"
        case hasMelanomaWoman = "melanomaWoman"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Self.CodingKeys)
        
        try container.encode(gender, forKey: .gender)
        try container.encode(age, forKey: .age)
        try container.encode(weight, forKey: .weight)
        try container.encode(height, forKey: .height)
        
        if let smoke = smoke {
            try container.encode(smoke, forKey: .smoke)
        }
        
        if let alcohol = alcohol {
            try container.encode(alcohol, forKey: .alcohol)
        }
        
        if bpUndefined {
            try container.encode("true", forKey: .bpUndefined)
        } else {
            try container.encode(bloodPressureTop, forKey: .bloodPressureTop)
            try container.encode(bloodPressureLow, forKey: .bloodPressureLow)
        }
        
        try container.encode(["\(hasHighCholesterol)"], forKey: .hasHighCholesterol)
        try container.encode(["\(hasDiabetes)"], forKey: .hasDiabetes)
        try container.encode(["\(hasBrokenBone)"], forKey: .hasBrokenBone)
        try container.encode(["\(hasFamilyInsult)"], forKey: .hasFamilyInsult)
        try container.encode(["\(hasFamilyInfarct)"], forKey: .hasFamilyInfarct)
        try container.encode(["\(hasFamilyRelativeHipBroke)"], forKey: .hasFamilyRelativeHipBroke)
        try container.encode(["\(hasFamilyDiabetis)"], forKey: .hasFamilyDiabetis)
        try container.encode(["\(hasChronicLungs)"], forKey: .hasChronicLungs)
        try container.encode(["\(hasChronicHeart)"], forKey: .hasChronicHeart)
        try container.encode(["\(hasChronicLiver)"], forKey: .hasChronicLiver)
        try container.encode(["\(hasChronicStomach)"], forKey: .hasChronicStomach)
        try container.encode(["\(hasChronicKidneys)"], forKey: .hasChronicKidneys)
        try container.encode(["\(hasHiv)"], forKey: .hasHiv)
        try container.encode(["\(hasProstateCancer)"], forKey: .hasProstateCancer)
        try container.encode(["\(hasCervicalCancerWoman)"], forKey: .hasCervicalCancerWoman)
        try container.encode(["\(hasColonCancerMan)"], forKey: .hasColonCancerMan)
        try container.encode(["\(hasColonCancerWoman)"], forKey: .hasColonCancerWoman)
        try container.encode(["\(hasStomachCancerMan)"], forKey: .hasStomachCancerMan)
        try container.encode(["\(hasStomachCancerWoman)"], forKey: .hasStomachCancerWoman)
        try container.encode(["\(hasLungsCancerMan)"], forKey: .hasLungsCancerMan)
        try container.encode(["\(hasLungsCancerWoman)"], forKey: .hasLungsCancerWoman)
        try container.encode(["\(hasMelanomaMan)"], forKey: .hasMelanomaMan)
        try container.encode(["\(hasMelanomaWoman)"], forKey: .hasMelanomaWoman)
        
        if let prostateCancerDetails = prostateCancerDetails {
            try container.encode(prostateCancerDetails.rawValue, forKey: .prostateCancerDetails)
        }
        
        if let stomachCancerDetails = stomachCancerDetails {
            try container.encode(stomachCancerDetails.rawValue, forKey: .stomachCancerDetails)
        }
        
        if let colonCancerDetails = colonCancerDetails {
            try container.encode(colonCancerDetails.rawValue, forKey: .colonCancerDetails)
        }
    }
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

enum ProstateCancerDetails: String, Codable {
    case morethan1
    case under65
    case over65
}

enum StomachCancerDetails: String, Codable {
    case morethan3
    case under40
    case under50
    case complex
    case none
}

enum ColonCancerDetails: String, Codable {
    case lessthan60
    case manyRelatives
    case over60
    case manyCousins
}
