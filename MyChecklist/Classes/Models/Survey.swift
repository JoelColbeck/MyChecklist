//
//  Survey.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import Foundation

enum SurveyError: Error {
    case genderWasNotChosen
}

struct Survey: Codable {
    var gender: Gender?
    var age: Int = 18
    var height: Int = 170
    var weight: Int = 70
    var smoke: Smoke?
    var alcohol: Alcohol?
    var bloodPressure: BloodPressure?
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
}

enum Gender: String, Codable, CaseIterable {
    case man
    case woman
}

enum Smoke: String, Codable, CaseIterable {
    case smokingNow
    case quitSmoking
    case noSmoking
}

enum Alcohol: String, Codable, CaseIterable {
    case heavyDrinker
    case lightDrinker
    case noDrinker
}

enum BloodPressure: String, Codable, CaseIterable {
    case low
    case normal
    case high
}

enum ProstateCancerDetails: String, Codable, CaseIterable {
    case morethan1
    case under65
    case over65
}

enum StomachCancerDetails: String, Codable, CaseIterable {
    case morethan3
    case under40
    case under50
    case complex
}

enum ColonCancerDetails: String, Codable, CaseIterable {
    case lessthan60
    case over60
    case manyRelatives
    case manyCousins
}
