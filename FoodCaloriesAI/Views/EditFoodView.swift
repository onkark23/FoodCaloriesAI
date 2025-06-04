// Views/EditFoodView.swift

import SwiftUI

struct EditFoodView: View {
    @ObservedObject var viewModel: EditFoodViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Edit Ingredients & Calories")
                .font(.title2)
                .bold()
            
            // Editable ingredients list
            ForEach(Array(viewModel.foodItem.ingredients.enumerated()), id: \.offset) { index, ingredient in
                HStack {
                    TextField("Ingredient", text: Binding(
                        get: { ingredient },
                        set: { newValue in
                            viewModel.updateIngredient(index, with: newValue)
                        }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            // Calories editor
            HStack {
                Text("Calories: \(viewModel.foodItem.calories)")
                Spacer()
                Button("-") {
                    viewModel.updateCalories(by: -10)
                }
                .buttonStyle(.bordered)
                
                Button("+") {
                    viewModel.updateCalories(by: 10)
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
            
            Button("Save & Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
