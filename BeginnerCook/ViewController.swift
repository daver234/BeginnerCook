/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
 *
 * modified by Dave Rothschild May 5, 2016
*/

import UIKit

let herbs = HerbModel.all()

class ViewController: UIViewController {
  
  @IBOutlet var listView: UIScrollView!
  @IBOutlet var bgImage: UIImageView!
  var selectedImage: UIView?
  
  //MARK: Actions
  
  @IBAction func didTapImageView(tap: UITapGestureRecognizer) {
    let index = tap.view!.tag
    let selectedHerb = herbs[index]
    selectedImage = tap.view!
    
    //present details view controller
    if let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("HerbDetailsViewController") as? HerbDetailsViewController {
      herbDetails.herb = selectedHerb
      herbDetails.transitioningDelegate = self
      presentViewController(herbDetails, animated: true, completion: nil)
    }
  }
  
}

extension ViewController: UIViewControllerTransitioningDelegate {
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissAnimator()
  }
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animator = PresentAnimator()
    animator.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame, toView: nil)
    return animator
  }
}

///////////////////////////////////////
//
//    Starter project code
//
///////////////////////////////////////

extension ViewController {
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if listView.subviews.count < herbs.count {
      listView.viewWithTag(0)?.tag = 1000 //prevent confusion when looking up images
      setupList()
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  func setupList() {
    
    for i in 0 ..< herbs.count {
      
      //create image view
      let imageView  = UIImageView(image: UIImage(named: herbs[i].image))
      imageView.tag = i
      imageView.contentMode = .ScaleAspectFill
      imageView.userInteractionEnabled = true
      imageView.layer.cornerRadius = 20.0
      imageView.layer.masksToBounds = true
      listView.addSubview(imageView)
      
      //attach tap detector
      imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapImageView(_:))))
    }
    
    listView.backgroundColor = UIColor.clearColor()
    positionListItems()
  }
  
  //position all images inside the list
  func positionListItems() {
    
    let itemHeight: CGFloat = listView.frame.height * 1.33
    let aspectRatio = UIScreen.mainScreen().bounds.height / UIScreen.mainScreen().bounds.width
    let itemWidth: CGFloat = itemHeight / aspectRatio
    
    let horizontalPadding: CGFloat = 10.0
    
    for i in 0 ..< herbs.count {
      let imageView = listView.viewWithTag(i) as! UIImageView
      imageView.frame = CGRect(
        x: CGFloat(i) * itemWidth + CGFloat(i+1) * horizontalPadding, y: 0.0,
        width: itemWidth, height: itemHeight)
    }
    
    listView.contentSize = CGSize(
      width: CGFloat(herbs.count) * (itemWidth + horizontalPadding) + horizontalPadding,
      height:  0)
  }
}