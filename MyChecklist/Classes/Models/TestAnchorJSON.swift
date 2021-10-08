//
//  TestAnchorJSON.swift
//  MyPlan
//
//  Created by Башир Арсланалиев on 25.05.2021.
//

import Foundation

struct TestAnchor: Codable, Hashable {
    let testAnchor: String
    let testName: String
    let category: String
    let description: String
    let importance: Importance
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(testAnchor)
    }
}

enum Importance: String, Codable {
    case high = "importanceHigh"
    case medium = "importanceMed"
    case low = "importanceLow"
}

let testAnchorJSON = """
    [
        {
            "testAnchor":"cholesterolTest",
            "testName": "Тест на холестерин",
            "category": "🩸 Кровь",
            "description": "Описание теста на несколько строк",
            "importance": "importanceHigh"
        },
        {
            "testAnchor":"cholesterolTest40+",
            "testName": "Тест на холестерин",
            "category": "🩸 Кровь",
            "description": "Описание теста на несколько строк",
            "importance": "importanceHigh"
        },
        {
            "testAnchor":"aneurysmScreening",
            "testName": "Тест на холестерин",
            "category": "🩸 Кровь",
            "description": "Описание теста на несколько строк",
            "importance": "importanceHigh"
            
        },
        {
            "testAnchor":"aoas",
            "testName": "Abdominal aortic aneurysm screening",
            "category": "❤️ Heart",
            "description": "Очень длинное описание теста на несколько строк",
            "importance": "importanceMed"
            
        },
        {
            "testAnchor":"hiv",
            "testName": "Тест на вирус имуннодифицита человека",
            "category": "🩸 Кровь",
            "description": "Описание теста на несколько строк",
            "importance": "importanceLow"
            
        },
        {
            "testAnchor":"CT-l",
            "testName": "КТ легких",
            "category": "⚡ Лучевая диагностика",
            "description": "〰️КТ легких – исследование для ранней диагностики рака легких.",
            "importance": "importanceLow"
            
        },
        {
            "testAnchor":"CT-h",
            "testName": "КТ легких",
            "category": "⚡ Лучевая диагностика",
            "description": "Ежегодное КТ рекомендуется, если вы продолжаете курить.",
            "importance": "importanceHigh"
            
        },
        {
            "testAnchor":"diabetis",
            "testName": "Diabetic Eye Screening",
            "category": "👩‍⚕️ Осмотр",
            "description": "",
            "importance": "importanceHigh"
            
        },
        {
            "testAnchor":"breastcancer45",
            "testName": "Мамография",
            "category": "⚡ Лучевая диагностика",
            "description": "",
            "importance": "importanceHigh"
            
        },
        {
            "testAnchor":"breastcancer55",
            "testName": "Мамография",
            "category": "⚡ Лучевая диагностика",
            "description": "",
            "importance": "importanceHigh"
            
        },
        {
            "testAnchor":"psa40",
            "testName": "Общий ПСА",
            "category": "🩸 Кровь",
            "description": "",
            "importance": "importanceHigh"
            
        },
        {
            "testAnchor":"psa45",
            "testName": "Общий ПСА",
            "category": "🩸 Кровь",
            "description": "",
            "importance": "importanceHigh"
            
        },
        {
            "testAnchor":"psa-baseline",
            "testName": "Исходный уровень ПСА",
            "category": "🩸 Кровь",
            "description": "",
            "importance": "importanceHigh"
        },
        {
            "testAnchor":"psa65",
            "testName": "Общий ПСА",
            "category": "🩸 Кровь",
            "description": "",
            "importance": "importanceHigh"
            
        },
        {
            "testAnchor":"colonoscopy50+",
            "testName": "Колоноскопия",
            "category": "🩺  Исследование",
            "description": "",
            "importance": "importanceMed"
            
        },
        {
            "testAnchor":"colonoscopy40+",
            "testName": "Колоноскопия",
            "category": "🩺  Исследование",
            "description": "",
            "importance": "importanceMed"},
        {
            "testAnchor":"colonoscopy75+",
            "testName": "Колоноскопия",
            "category": "🩺  Исследование",
            "description": "",
            "importance": "importanceLow"},
        {
            "testAnchor":"FOBT",
            "testName": "Анализ кала на скрытую кровь",
            "category": "💩 Исследование",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"HPV",
            "testName": "Вакцина от вируса папилломы человека",
            "category": "💉 Прививка",
            "description": "",
            "importance": "importanceMed"
            
        },
        {
            "testAnchor":"herpesVaccine",
            "testName": "Прививка от опоясывающего герпеса",
            "category": "💉 Прививка",
            "description": "",
            "importance": "importanceMed"
            
        },
        {
            "testAnchor":"pneumococcus",
            "testName": "Прививка от пневмококкока",
            "category": "💉 Прививка",
            "description": "",
            "importance": "importanceMed"
            
        },
        {
            "testAnchor":"melanoma",
            "testName": "Визуальный осмотр кожи",
            "category": "💉 Прививка",
            "description": "",
            "importance": "importanceMed"
            
        },
        {
            "testAnchor":"dispancer",
            "testName": "Диспансеризация",
            "category": "💉 Прививка",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"dantist",
            "testName": "Осмотр Стоматолога",
            "category": "👄 Осмотр",
            "description": "",
            "importance": "importanceMed"
            
        },
        {
            "testAnchor":"vitaminD",
            "testName": "Тест на витамин Д",
            "category": "🩸 Осмотр",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"diabeticEye",
            "testName": "Исследование глазного дна",
            "category": "👩‍⚕️ Осмотр",
            "description": "",
            "importance": "importanceHigh"
        },
        {
            "testAnchor":"FPG",
            "testName": "Уровень глюкозы натощак",
            "category": "👩‍⚕️ Осмотр",
            "description": "",
            "importance": "importanceHigh"
        },
        {
            "testAnchor":"breastcancer",
            "testName": "Мамография",
            "category": "⚡ Лучевая диагностика",
            "description": "",
            "importance": "importanceHigh"
        },
        {
            "testAnchor":"stomachCancerGeneticTest",
            "testName": "Генетический тест на вероятность рака желудка",
            "category": "🧬 Генетический тест",
            "description": "",
            "importance": "importanceHigh"
        },
        {
            "testAnchor":"psa",
            "testName": "Общий ПСА",
            "category": "🩸 Кровь",
            "description": "",
            "importance": "importanceHigh"
        },
        {
            "testAnchor":"colonoscopy",
            "testName": "Колоноскопия",
            "category": "🩺  Исследование",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"gastroscopy",
            "testName": "Колоноскопия",
            "category": "🩺  Исследование",
            "description": "",
            "importance": "importanceLow"
        },
        {
            "testAnchor":"dentist",
            "testName": "Осмотр Стоматолога",
            "category": "🦷 Осмотр",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"osteoporosis",
            "testName": "Тест плотности костной ткани",
            "category": "⚡ Лучевая диагностика",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"pillar",
            "testName": "Привика от столбняка",
            "category": "💉 Прививка",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"diphtheria",
            "testName": "Привика от дифтерии",
            "category": "💉 Прививка",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"measles",
            "testName": "Привика от кори",
            "category": "💉 Прививка",
            "description": "",
            "importance": "importanceMed"
        },
        {
            "testAnchor":"Dietologist",
            "testName": "Консультация Диетолога",
            "category": "👩‍⚕️ Осмотр",
            "description": "",
            "importance": "importanceMed"
        },
    ]
"""
