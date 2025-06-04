import Foundation
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage? = nil
    @Published var foodItem: FoodItem? = nil
    @Published var isLoading = false
    
    private let openAIService = OpenAIService()
    
    func analyzeImage() {
        guard let image = capturedImage else { return }
        
        isLoading = true
        openAIService.analyzeFoodImage(image) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let foodItem):
                    self?.foodItem = foodItem
                case .failure(let error):
                    print("API Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

