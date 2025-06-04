// ViewModels/EditFoodViewModel.swift

import Foundation
import SwiftUI

class EditFoodViewModel: ObservableObject {
    @Published var foodItem: FoodItem
    
    init(foodItem: FoodItem) {
        self.foodItem = foodItem
    }
    
    func updateCalories(by amount: Int) {
        foodItem.calories += amount
    }
    
    func updateIngredient(_ index: Int, with newValue: String) {
        guard foodItem.ingredients.indices.contains(index) else { return }
        foodItem.ingredients[index] = newValue
    }
}
