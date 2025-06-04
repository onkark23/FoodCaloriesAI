// Services/OpenAIService.swift

import Foundation
import UIKit

class OpenAIService {
    private let apiKey = "<YOUR-API-KEY-HERE>"  // Move to .xcconfig or environment for security
    
    func analyzeFoodImage(_ image: UIImage, completion: @escaping (Result<FoodItem, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image."])))
            return
        }
        
        let base64String = imageData.base64EncodedString()
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",  // Vision-capable model
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": "Analyze this food photo and return calories and nutrients in structured JSON."
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64String)"
                            ]
                        ]
                    ]
                ]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                // Parse your structured JSON from OpenAI’s response
                // Let’s assume OpenAI returns structured JSON as part of `choices[0].message.content`:
                if let jsonData = decoded.choices.first?.message.content.data(using: .utf8) {
                    let foodItem = try JSONDecoder().decode(FoodItem.self, from: jsonData)
                    completion(.success(foodItem))
                } else {
                    completion(.failure(NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse food data."])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// Supporting structs for OpenAI response
struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let content: String
}
