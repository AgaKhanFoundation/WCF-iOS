import UIKit

class APIClient {
  
  static var shared = APIClient()
  
  private var baseURLString = "" // TODO: Add baseurl in AppConfig
  private let session: URLSession
  
  init() {
    let config = URLSessionConfiguration.default
    // TODO: Add authorization headers
    session = URLSession(configuration: config)
  }
  
  typealias APIClientResultCompletion = (Result) -> Void
  
  func request(_ request: Request, completion: @escaping APIClientResultCompletion) {
    print("-> \(request.endpoint.rawValue)")
    
    var urlComponents = URLComponents(string: baseURLString)
    urlComponents?.path.append("/\(request.endpoint.rawValue)")
    urlComponents?.query = request.queryString
    
    guard let url = urlComponents?.url else {
      print("request: \(request) could not be created")
      handle(completion, result: .error(.request))
      return
    }
    
    var urlRequest = URLRequest(url: url)
    
    // TODO: Add user token if needed here
    
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpBody = request.paramData
    
    let task = session.dataTask(with: urlRequest) { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) in
      print("<- \(request.endpoint.rawValue)")
      
      guard let httpResponse = urlResponse as? HTTPURLResponse else {
        print("Error: Response")
        self?.handle(completion, result: .error(.response))
        return
      }
      
      guard error == nil else {
        print("Error: \(error.debugDescription)")
        self?.handle(completion, result: .error(.networking(error)))
        return
      }
      
      guard
        let data = data,
        let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON
      else {
        print("Error: JSON Parsing")
        self?.handle(completion, result: .error(.parsing))
        return
      }
      
      let response = Response(response: json, request: request, code: httpResponse.statusCode)
      
      self?.handle(completion, result: .success(response))
    }
    
    task.resume()
  }
  
  private func handle(_ completion: @escaping APIClientResultCompletion, result: Result) {
    onMain {
      completion(result)
    }
  }
}
