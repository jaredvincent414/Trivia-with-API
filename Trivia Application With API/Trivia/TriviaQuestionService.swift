//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by vincent Jared on 3/27/25.
//
import Foundation

class TriviaQuestionService {
    static func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=10"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.results)
                }
            } catch {
                print("Decoding error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
