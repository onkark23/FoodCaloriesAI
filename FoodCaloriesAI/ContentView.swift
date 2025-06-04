import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var isShowingCamera = false
    @State private var isEditingFoodItem = false

    var body: some View {
        VStack(spacing: 16) {
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(8)
            } else {
                Text("No Image Captured")
                    .foregroundColor(.gray)
            }
            
            Button("Open Camera") {
                isShowingCamera = true
            }
            .padding()
            .background(Color.blue.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if viewModel.capturedImage != nil {
                Button("Analyze Food") {
                    viewModel.analyzeImage()
                }
                .padding()
                .background(Color.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let foodItem = viewModel.foodItem {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients: \(foodItem.ingredients.joined(separator: ", "))")
                    Text("Calories: \(foodItem.calories)")
                    Text("Nutrients:")
                    ForEach(foodItem.nutrients.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        Text("\(key): \(value)")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                Button("Edit Data") {
                    isEditingFoodItem = true
                }
                .padding()
                .background(Color.orange.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .sheet(isPresented: $isShowingCamera) {
            CameraView(image: $viewModel.capturedImage)
        }
        .sheet(isPresented: $isEditingFoodItem) {
            if let foodItem = viewModel.foodItem {
                EditFoodView(viewModel: EditFoodViewModel(foodItem: foodItem))
            }
        }
        .padding()
    }
}
