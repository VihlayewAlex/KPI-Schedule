//
//  ScheduleTutorialVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/22/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit
import Pageboy

class ScheduleTutorialVC: UIViewController {

    @IBOutlet weak var circle0: UIView!
    @IBOutlet weak var circle1: UIView!
    @IBOutlet weak var circle2: UIView!
    @IBOutlet weak var circle3: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var pagesContainerView: UIView!
    
    var circles: [UIView] { return [circle0, circle1, circle2, circle3] }
    
    private let pageVC = PageboyViewController()
    
    private let viewControllers = [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorialPageDaysVC"),
                                   UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorialPageWeeksVC"),
                                   UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorialPageFavouritesVC"),
                                   UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorialPageTimelineVC")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageVC.dataSource = self
        pageVC.delegate = self
        
        addChild(pageVC)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        pagesContainerView.addSubview(pageVC.view)
        pagesContainerView.leftAnchor.constraint(equalTo: pageVC.view.leftAnchor).isActive = true
        pagesContainerView.topAnchor.constraint(equalTo: pageVC.view.topAnchor).isActive = true
        pagesContainerView.rightAnchor.constraint(equalTo: pageVC.view.rightAnchor).isActive = true
        pagesContainerView.bottomAnchor.constraint(equalTo: pageVC.view.bottomAnchor).isActive = true
        pageVC.didMove(toParent: self)
    }
    
    private func setPositionIndex(to positionIndex: Int) {
        UIView.animate(withDuration: 0.1, animations: {
            self.circles.forEach({ (circle) in
                circle.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
            })
        }, completion: { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.circles[positionIndex].backgroundColor = UIColor(red: 0.99, green: 0.31, blue: 0.43, alpha: 1.0)
                self.doneButton.isHidden = (positionIndex != self.circles.count - 1)
            })
        })
    }
    
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ScheduleTutorialVC: PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) { }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) { }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) { }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        setPositionIndex(to: index)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}
