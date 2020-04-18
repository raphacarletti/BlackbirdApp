import SwiftUI

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }

    private func configViews() {
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(), tag: 0)

        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(), tag: 1)

        let profileViewController = ProfileViewController(profileType: .loggedUser)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(), tag: 2)

        let tabBarList = [feedViewController, searchViewController, profileViewController]
        viewControllers = tabBarList
    }
}
