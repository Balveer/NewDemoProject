import Foundation

struct NetworkInspection: Codable {
    let id: Int
    let inspectionType: InspectionType
    let area: Area
    let survey: Survey

    struct InspectionType: Codable {
        let id: Int
        let name: String
        let access: String
    }

    struct Area: Codable {
        let id: Int
        let name: String
    }

    struct Survey: Codable {
        let id: Int
        let categories: [Category]

        struct Category: Codable {
            let id: Int
            let name: String
            let questions: [Question]

            struct Question: Codable {
                let id: Int
                let name: String
                let answerChoices: [AnswerChoice]
                let selectedAnswerChoiceId: Int?

                struct AnswerChoice: Codable {
                    let id: Int
                    let name: String
                    let score: Double
                }
            }
        }
    }
}
