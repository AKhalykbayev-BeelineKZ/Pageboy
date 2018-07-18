//
//  PageViewController.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController {
    

    // MARK: Outlets
    
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!

    
    // MARK: Properties
    
    var gradient: GradientViewController? {
        return parent as? GradientViewController
    }
    
    var previousBarButton: UIBarButtonItem?
    var nextBarButton: UIBarButtonItem?
    
    var pageControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Pageboy", bundle: Bundle.main)
        
        var viewControllers = [UIViewController]()
        for i in 0 ..< 5 {
            let viewController = storyboard.instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
            viewController.index = i + 1
            viewControllers.append(viewController)
        }
        return viewControllers
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButtons()
        
        dataSource = self
        delegate = self
        
        updateStatusLabels()
        updateBarButtonStates(index: currentIndex ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradient?.gradients = Gradients.all
    }

    func updateStatusLabels() {
        self.pageCountLabel.text = "Page Count: \(self.pageCount ?? 0)"
        let offsetValue =  navigationOrientation == .horizontal ? self.currentPosition?.x : self.currentPosition?.y
        self.offsetLabel.text = "Current Position: " + String(format: "%.3f", offsetValue ?? 0.0)
        self.pageLabel.text = "Current Page: " + String(describing: self.currentIndex ?? 0)
    }
    
    
    // MARK: Actions
    
    @objc func nextPage(_ sender: UIBarButtonItem) {
        scrollToPage(.next, animated: true)
    }
    
    @objc func previousPage(_ sender: UIBarButtonItem) {
        scrollToPage(.previous, animated: true)
    }
}

// MARK: PageboyViewControllerDataSource
extension PageViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return pageControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageIndex) -> UIViewController? {
        return pageControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> Page? {
        return nil
    }
}

// MARK: PageboyViewControllerDelegate
extension PageViewController: PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: Int,
                               direction: NavigationDirection,
                               animated: Bool) {
//        print("willScrollToPageAtIndex: \(index)")
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: NavigationDirection,
                               animated: Bool) {
//        print("didScrollToPosition: \(position)")
        
        let isVertical = navigationOrientation == .vertical
        gradient?.gradientOffset = isVertical ? position.y : position.x
        self.updateStatusLabels()
        
        self.updateBarButtonStates(index: pageboyViewController.currentIndex ?? 0)
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: Int,
                               direction: NavigationDirection,
                               animated: Bool) {
//        print("didScrollToPageAtIndex: \(index)")

        gradient?.gradientOffset = CGFloat(index)
        updateStatusLabels()
        updateBarButtonStates(index: index)
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageIndex) {
    }
}

