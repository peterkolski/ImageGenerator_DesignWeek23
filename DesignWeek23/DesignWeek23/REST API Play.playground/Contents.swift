import Foundation

struct Engine: Codable {
    let id: String
    let name: String
}

let apiKey = "sk-zUcWdOuTDjZR3gURbarc49AI7YOS5DMNk8b07V9g5v8hkVGl"
let urlString = "https://api.stability.ai/v1/engines/list"

guard let url = URL(string: urlString) else {
    fatalError("Invalid URL")
}

var request = URLRequest(url: url)
request.addValue(apiKey, forHTTPHeaderField: "Authorization")

URLSession.shared.dataTask(with: request) { (data, response, error) in
    guard let data = data else {
        fatalError("Error: \(error?.localizedDescription ?? "Unknown error")")
    }
    
    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
        if let engines = try? JSONDecoder().decode([Engine].self, from: data) {
            print("Available engine IDs:")
            engines.forEach { engine in
                print("- \(engine.id): \(engine.name)")
            }
        } else {
            fatalError("Invalid server response")
        }
    } else {
        fatalError("Invalid server response")
    }
}.resume()
