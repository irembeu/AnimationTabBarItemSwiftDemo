//
//  GuideViewController.swift
//  AnimationTabBarItemsDemo
//
//  Created by 刘光军 on 16/3/5.
//  Copyright © 2016年 刘光军. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController {
    
    fileprivate var collectionView:UICollectionView?
    fileprivate var imageNames = ["guide_40_1", "guide_40_2", "guide_40_3", "guide_40_4"]
    fileprivate let cellIdentifier = "GuideCell"
    fileprivate var isHiddenNextButton = true
    fileprivate var pageController = UIPageControl(frame: CGRect(x: 0, y: ScreenHeight - 50, width: ScreenWidth, height: 20))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        createCollectionView()
        createPageControll()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- UICollectionView
    func createCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = ScreenBounds.size
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: ScreenBounds, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.register(GuideCollectionViewCell.self , forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView!)
    }
    
    fileprivate func createPageControll() {
        pageController.numberOfPages = imageNames.count
        pageController.currentPage = 0
        view.addSubview(pageController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GuideViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GuideCollectionViewCell
        cell.newImage = UIImage(named: imageNames[(indexPath as NSIndexPath).row])
        if (indexPath as NSIndexPath).row != imageNames.count - 1 {
            cell.setNextBtnHidden(true)
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x == ScreenWidth * CGFloat(imageNames.count - 1) {
            let cell = collectionView?.cellForItem(at: IndexPath(row: imageNames.count - 1, section: 0)) as! GuideCollectionViewCell
            cell.setNextBtnHidden(false)
            isHiddenNextButton = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x != ScreenWidth * CGFloat(imageNames.count - 1) && !isHiddenNextButton && scrollView.contentOffset.x > ScreenWidth * CGFloat(imageNames.count - 2) {
            let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: IndexPath(row: imageNames.count - 1, section: 0)) as! GuideCollectionViewCell
            cell.setNextBtnHidden(true)
            isHiddenNextButton = true
        }
        pageController.currentPage = Int(scrollView.contentOffset.x / ScreenWidth + 0.5)
    }
}


