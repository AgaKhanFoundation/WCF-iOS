import Foundation

// MARK: - Request

typealias JSON = [String: Any]

extension Dictionary {
  func queryParams() -> String {
    var queryParams = [String]()
    
    for (key, value) in self {
      queryParams.append("\(key)=\(value)")
    }
    
    return queryParams.joined(separator: "&")
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case delete = "DELETE"
  case patch = "PATCH"
  case post = "POST"
  case put = "PUT"
}

enum Endpoint {
  
  var rawValue: String {
    switch self {
    case .teams: return "/teams"
    case .team(let id): return "/teams/\(id)"
    }
  }
  
  case teams
  case team(Int64)
}

struct Request {
  let endpoint: Endpoint
  let method: HTTPMethod
  let params: JSON?
  let query: JSON?
  
  init(endpoint: Endpoint,
       method: HTTPMethod = .get,
       params: JSON? = nil,
       query: JSON? = nil) {
    self.endpoint = endpoint
    self.method = method
    self.params = params
    self.query = query
  }
  
  var queryString: String? {
    guard let query = query else { return nil }
    return query.queryParams()
  }
  
  var paramData: Data? {
    guard let params = params else { return nil }
    return try? JSONSerialization.data(withJSONObject: params, options: [])
  }
}

// MARK: - Response

struct Response {
  let response: JSON
  let request: Request
  let code: Int
}

// MARK: - Errors

enum APIClientError: Error {
  case request
  case response
  case api(Error?)
  case parsing
  case networking(Error?)
}

// MARK: - Result

enum Result {
  case success(Response)
  case error(APIClientError)
  
  var response: Response? {
    switch self {
    case .success(let response):
      return response
    default:
      return nil
    }
  }
  
  var isSuccess: Bool {
    switch self{
    case .success(let response):
      return response.code == 200
    default:
      return false
    }
  }
}
