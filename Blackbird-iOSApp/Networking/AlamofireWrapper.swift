import Foundation
import Alamofire

final class AlamofireWrapper {
    static func request<T: Decodable>(_ request: BlackbirdRequest, completion: @escaping (Result<T, BlackbirdError>) -> Void) {
        let request = AF.request(request.urlString, method: request.method, parameters: request.parameters, encoding: request.encoding)

        request.responseDecodable(of: T.self, queue: .main) { (result: DataResponse<T, AFError>) in
            if let response = result.value {
                completion(.success(response))
            } else {
                completion(.failure(BlackbirdError.unknown))
            }
        }
    }
}
