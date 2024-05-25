import Foundation

class InvertextoAPI {

    static func validate(cpfCnpj value: String, completion: @escaping (Result<(Bool, String), Error>) -> Void) {
        
        let token = "7891|dHDPmBb8sK0WInRmseo0pMa9PxxbmSpk"
        let host = "https://api.invertexto.com/v1/validator?token="
        
        let url = URL(string: "\(host)\(token)&value=\(value)")!

        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [] ) as? [String : Any] {
                    if let valid = json["valid"] as? Bool {
                        
                        if let formatted = json["formatted"] as? String {
                            completion(.success((valid, formatted)))
                        }
                        
                        completion(.success((valid, "")))
                    }
                }
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
