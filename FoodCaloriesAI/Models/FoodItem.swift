
import Foundation

struct FoodItem: Codable, Identifiable {
    var id = UUID()
    var ingredients: [String]
    var calories: Int
    var nutrients: [String: String]
}

