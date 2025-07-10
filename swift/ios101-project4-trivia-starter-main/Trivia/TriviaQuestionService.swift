//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Honore Jabiro on 7/8/25.
//

import Foundation

class TriviaQuestionService {
   
    static func fetchQuestions(
        amount: Int,
        completion: (([TriviaQuestion]) -> Void)? = nil)
    {
       
        let parameters = "amount=10"
        guard let url = URL(string: "https://opentdb.com/api.php?\(parameters)") else {
            assertionFailure("Invalid URL")
            return
        }
       
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
               
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
               
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
           
            guard httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
           
            guard let data = data else {
                assertionFailure("No data received")
                return
            }
           
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TriviaAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion?(response.results)
                }
            } catch {
                assertionFailure("Failed to decode: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
