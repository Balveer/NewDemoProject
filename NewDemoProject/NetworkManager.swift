import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5001/api/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
        task.resume()
    }

    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5001/api/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
        task.resume()
    }

    func startInspection(completion: @escaping (NetworkInspection?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5001/api/inspections/start") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let inspection = try? JSONDecoder().decode(NetworkInspection.self, from: data)
            completion(inspection)
        }
        task.resume()
    }

    func submitInspection(inspection: NetworkInspection, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5001/api/inspections/submit") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let inspectionDict: [String: Any] = [
            "id": inspection.id,
            "inspectionType": [
                "id": inspection.inspectionType.id,
                "name": inspection.inspectionType.name,
                "access": inspection.inspectionType.access
            ],
            "area": [
                "id": inspection.area.id,
                "name": inspection.area.name
            ],
            "survey": [
                "id": inspection.survey.id,
                "categories": inspection.survey.categories.map { category in
                    return [
                        "id": category.id,
                        "name": category.name,
                        "questions": category.questions.map { question in
                            return [
                                "id": question.id,
                                "name": question.name,
                                "answerChoices": question.answerChoices.map { answerChoice in
                                    return [
                                        "id": answerChoice.id,
                                        "name": answerChoice.name,
                                        "score": answerChoice.score
                                    ]
                                },
                                "selectedAnswerChoiceId": question.selectedAnswerChoiceId as Any
                            ]
                        }
                    ]
                }
            ]
        ]
        
        let inspectionData = try? JSONSerialization.data(withJSONObject: ["inspection": inspectionDict], options: .fragmentsAllowed)
        request.httpBody = inspectionData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
        task.resume()
    }
}




