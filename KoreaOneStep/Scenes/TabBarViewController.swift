//
//  TabBarViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = MainViewController()
        let bookmarkVC = BookmarkViewController()
        let settingVC = SettingViewController()
        
        let bookmarkNav = UINavigationController(rootViewController: bookmarkVC)
        let mainNav = UINavigationController(rootViewController: mainVC)
        let settingNav = UINavigationController(rootViewController: settingVC)
        
        mainNav.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        bookmarkNav.tabBarItem = UITabBarItem(
            title: "북마크",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        settingNav.tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        tabBar.tintColor = .black
        
        setViewControllers([mainNav, bookmarkNav, settingNav], animated: false)
    }
}
