/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Combine

enum UnsplashAPI {

  /// Replace with new signature. Now, the method doesn’t take a completion closure as a parameter. Instead, it returns a publisher, with an output type of RandomImageResponse and a failure type of GameError.
  static func randomImage(gameState: GameState) throws -> AnyPublisher<RandomImageResponse, GameError> {
    
    guard
      let url = URL(string: gameState.url)
    else {
      throw GameError.invalidURL
    }

    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    let session = URLSession(configuration: config)

    var urlRequest = URLRequest(url: url)
    urlRequest.addValue("Accept-Version", forHTTPHeaderField: "v1")
    
    /// 1. You get a publisher from the URL session for your URL request. This is a URLSession.DataTaskPublisher, which has an output type of (data: Data, response: URLResponse). That’s not the right output type, so you’re going to use a series of operators to get to where you need to be.
    return session.dataTaskPublisher(for: urlRequest)
    
    /// 2. Apply the tryMap operator. This operator takes the upstream value and attempts to convert it to a different type, with the possibility of throwing an error. There is also a map operator for mapping operations that can’t throw errors.
      .tryMap { response in
        guard
          let httpURLResponse = response.response as? HTTPURLResponse,
          /// 3. Check for 200 OK HTTP status.
          httpURLResponse.statusCode == 200
        else {
          /// 4. Throw the custom GameError.statusCode error if you did not get a 200 OK HTTP status.
          throw GameError.statusCode
        }
        /// 5. Return the response.data if everything is OK. This means the output type of your chain is now Data
        return response.data
      }
    
      /// 6. Apply the decode operator, which will attempt to create a RandomImageResponse from the upstream value using JSONDecoder. Your output type is now correct!
      .decode(type: RandomImageResponse.self, decoder: JSONDecoder())
    
      /// 7. Your failure type still isn’t quite right. If there was an error during decoding, it won’t be a GameError. The mapError operator lets you deal with and map any errors to your preferred error type, using the function you added to GameError.
      .mapError { GameError.map($0) }
    
    /// 8. If you were to check the return type of mapError at this point, you would be greeted with something quite horrific. The .eraseToAnyPublisher operator tidies all that mess up so you’re returning something more usable.
      .eraseToAnyPublisher()
  }
}
