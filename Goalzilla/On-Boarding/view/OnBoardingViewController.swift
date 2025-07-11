//
//  OnBoardingViewController.swift
//  Goalzilla
//
//  Created by Abdelrahman Elshreif on 14/5/25.
//

import UIKit

class OnBoardingViewController: UIViewController  , OnBoardingViewDelegete{
  
    @IBOutlet weak var onBoardingPageControl: UIPageControl!
    @IBOutlet weak var onBoardingCollectionView: UICollectionView!
    @IBOutlet weak var nextOnBoardingPageBtn: UIButton!
    
    var slides:[OnBoardingSlide] = []
    let presenter = OnBoardingPresenter()
    static let identifier:String = "OnBoardingCollectionViewCell"
    
    var currentPage = 0 {
        didSet{
            onBoardingPageControl.currentPage = currentPage	
            if currentPage == slides.count-1 {
                nextOnBoardingPageBtn.setTitle("Get Started", for: .normal)
            }else{
                nextOnBoardingPageBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        presenter.getSlidesData()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
  
    func renderOnBoardingSlidesData(data: [OnBoardingSlide]) {
        slides = data
        onBoardingCollectionView.reloadData()
    }
    
  
    @IBAction func nextOnBoardingPageClicked(_ sender: Any) {
        (sender as! UIButton).ForBtnBig(DoThis: {
            if self.currentPage == self.slides.count-1 {
                self.presenter.userHasOnBoarded()
                self.navigateToMainScreen()
                return
            }else{
                self.currentPage += 1
                let indexPath = IndexPath(item: self.currentPage, section: 0)
                self.onBoardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        })
        
    }
    
}

// MARK: Navigation Function
extension OnBoardingViewController{
    func navigateToMainScreen(){
        let mainNavController = storyboard?.instantiateViewController(withIdentifier: "mainNavController") as! UINavigationController

        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = mainNavController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}

extension OnBoardingViewController: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = onBoardingCollectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingViewController.identifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:onBoardingCollectionView.frame.width, height: onBoardingCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        onBoardingPageControl.currentPage = currentPage
    }
        
}
