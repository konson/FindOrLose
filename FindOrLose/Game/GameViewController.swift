/// Copyright (c) 2019 Razeware LLC
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

import UIKit
import Combine

class GameViewController: UIViewController {
    // MARK: - Variables
    
    /// You’ll use this property to store all of your subscriptions.
    var subscriptions: Set<AnyCancellable> = []
    
    var gameState: GameState = .stop {
        didSet {
            switch gameState {
            case .play, .playDoggie:
                playGame()
            case .stop:
                stopGame()
            }
        }
    }
    
    var gameImages: [UIImage] = []
    
    ///You're now storing a subscription to the timer, rather than the timer itself. This can be represented with AnyCancellable in Combine.
    var gameTimer: AnyCancellable?
    var gameLevel = 0
    var gameScore = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameStateButton: UIButton!
    
    @IBOutlet weak var doggieGameStateButton: UIButton!
    
    @IBOutlet weak var gameScoreLabel: UILabel!
    
    @IBOutlet var gameImageView: [UIImageView]!
    
    @IBOutlet var gameImageButton: [UIButton]!
    
    @IBOutlet var gameImageLoader: [UIActivityIndicatorView]!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        //    precondition(!UnsplashAPI.accessToken.isEmpty, "Please provide a valid Unsplash access token!")
        
        title = "Find or Lose"
        gameScoreLabel.text = "Score: \(gameScore)"
    }
    
    // MARK: - Game Actions
    
    @IBAction func playOrStopAction(sender: UIButton) {
        gameState = gameState == .play ? .stop : .play
    }
    
    @IBAction func playDoggieOrStopAction(_ sender: Any) {
        gameState = gameState == .playDoggie ? .stop : .playDoggie
    }
    @IBAction func imageButtonAction(sender: UIButton) {
        let selectedImages = gameImages.filter { $0 == gameImages[sender.tag] }
        
        if selectedImages.count == 1 {
            playGame()
        } else {
            gameState = .stop
        }
    }
    
    // MARK: - Game Functions
    
  fileprivate func showAlert() {
    let alert = UIAlertController.init(title: "Oops", message: "That is a stinky URL.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true)
  }
  
  func playGame() {
        
        gameTimer?.cancel()
        
        gameStateButton.setTitle("Stop", for: .normal)
        
        gameLevel += 1
        title = "Level: \(gameLevel)"
        
        gameScoreLabel.text = "Score: \(gameScore)"
        
        gameScore += 200
        
        resetImages()
        startLoaders()
        
        /// 1. Get a publisher that will provide you with a random image value.

        let firstImage = try? UnsplashAPI.randomImage(gameState: gameState)
        /// 2. Apply the flatMap operator, which transforms the values from one publisher into a
        ///   new publisher. In this case you’re waiting for the output of the random image call, and
        ///   then transforming that into a publisher for the image download call.
            .flatMap { randomImageResponse in
                ImageDownloader.download(url: randomImageResponse.activeURL)
            }
        
        let secondImage = try? UnsplashAPI.randomImage(gameState: gameState)
            .flatMap { randomImageResponse in
                ImageDownloader.download(url: randomImageResponse.activeURL)
            }
    
    guard
      let first = firstImage,
      let second = secondImage
    else {
      showAlert()
      return
    }
        
        /// At this point, you have downloaded two random images. Now it’s time
        /// to, pardon the pun, combine them. You’ll use zip to do this.
        
        /// 1. zip makes a new publisher by combining the outputs of existing ones. It will wait until both
        ///   publishers have emitted a value, then it will send the combined values downstream.
        first.zip(second)
        
        /// 2. The receive(on:) operator allows you to specify where you want events from the
        ///   upstream to be processed. Since you’re operating on the UI, you’ll use the main dispatch queue.
            .receive(on: DispatchQueue.main)
        
        /// 3. It’s your first subscriber! sink(receiveCompletion:receiveValue:) creates a subscriber for you
        ///   which will execute those two closures on completion or receipt of a value.
            .sink(receiveCompletion: { [unowned self] completion in
                /// 4. Your publisher can complete in two ways — either it finishes or fails.
                ///   If there’s a failure, you stop the game.
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("Error: \(error)")
                    self.gameState = .stop
                }
            }, receiveValue: { [unowned self] first, second in
                
                /// 5. When you receive your two random images, add them to an array and
                ///   shuffle, then update the UI.
                self.gameImages = [first, second, second, second].shuffled()
                self.gameScoreLabel.text = "Score: \(self.gameScore)"
                
                
                /// Score!
                /// Schedule gameTimer to fire every very 0.1 seconds and decrease the score by 10.
                ///
                /// 1. You use the new API for vending publishers from Timer. The publisher will repeatedly
                ///   send the current date at the given interval, on the given run loop.
                self.gameTimer = Timer.publish(every: 0.1, on: RunLoop.main, in: .common)
                /// 2. The publisher is a special type of publisher that needs to be explicitly told to start or stop.
                ///   The .autoconnect operator takes care of this by connecting or disconnecting as soon as subscriptions
                ///   start or are canceled.
                    .autoconnect()
                /// 3. The publisher can't ever fail, so you don't need to deal with a completion. In this case, sink makes a
                ///   subscriber that just processes values using the closure you supply.
                    .sink { [unowned self] _ in
                        self.gameScoreLabel.text = "Score: \(self.gameScore)"
                        self.gameScore -= 10
                        
                        if self.gameScore < 0 {
                            self.gameScore = 0
                            self.gameTimer?.cancel()
                        }
                    }
                
                self.stopLoaders()
                self.setImages()
            })
        
        /// 6.
            .store(in: &subscriptions)
    }
    
    func stopGame() {
        
        subscriptions.forEach { $0.cancel() }
        
        gameTimer?.cancel()
        
        gameStateButton.setTitle("Play", for: .normal)
        
        title = "Find or Lose"
        
        gameLevel = 0
        
        gameScore = 0
        gameScoreLabel.text = "Score: \(gameScore)"
        
        stopLoaders()
        resetImages()
    }
    
    // MARK: - UI Functions
    
    func setImages() {
        if gameImages.count == 4 {
            for (index, gameImage) in gameImages.enumerated() {
                gameImageView[index].image = gameImage
            }
        }
    }
    
    func resetImages() {
        
        /// Assign an empty array that will remove all the references to the unused subscriptions.
        subscriptions = []
        gameImages = []
        
        gameImageView.forEach { $0.image = nil }
    }
    
    func startLoaders() {
        gameImageLoader.forEach { $0.startAnimating() }
    }
    
    func stopLoaders() {
        gameImageLoader.forEach { $0.stopAnimating() }
    }
}
