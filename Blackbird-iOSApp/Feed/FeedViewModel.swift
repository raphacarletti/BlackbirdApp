import Foundation

final class FeedViewModel {
    private let network = BlackbirdWorker()
    private(set) var tweets: [Tweet] = []
    var reloadTable: (() -> Void)?

    func getFeed() {
        network.getFeed { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tweets):
                self.tweets = tweets
                self.reloadTable?()
            case .failure(let error):
                print(error)
            }
        }
    }

    func post(text: String) {
        network.postTweet(text: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.getFeed()
            case .failure(let error):
                print(error)
            }
        }
    }
}
