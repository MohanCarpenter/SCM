//
//  ImageZoomView.swift
//  ImageZoom
//
//  Created by Avinash somani on 25/10/17.
//  Copyright © 2017 Kavyasoftech. All rights reserved.
//

import UIKit

class ImageZoom: ItemImageView {
    
    @IBInspectable open var willZoom: Bool = false
    @IBInspectable open var background_color: UIColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    
    override func draw(_ rect: CGRect) {
        setUIImage ()
        
        if willZoom {
            addClickButton (rect)
        }
    }
    
    var urlImage:String? = nil
    var dImage:String? = nil
    var boolScal:Bool = false
    var ai:UIActivityIndicatorView? = nil
    var superView:UIView? = nil
    
    func setImage(_ superView:UIView, _ urlImage:String?, _ dImage:String?, _ boolScal:Bool, _ ai:UIActivityIndicatorView?) {
        draw (self.frame)
        
        self.urlImage = urlImage
        self.dImage = dImage
        self.boolScal = boolScal
        self.ai = ai
        self.superView = superView
        
        setUIImage ()
    }
    
    func setUIImage () {
        if urlImage != nil {
            self.uiimage(urlImage, dImage, boolScal, ai)
        }
    }
    
    var btnOpen:UIButton? = nil
    
    func addClickButton (_ rect: CGRect) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_ :)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped (_ tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        openZoomView(tappedImage)
    }
    
    func openZoomView (_ sender:Any) {
        if viewZoomContainer == nil {
            viewZoomContainer = UIView()
            viewZoomContainer?.frame = UIScreen.main.bounds
            viewZoomContainer?.isUserInteractionEnabled = true
            
            viewZoomContainer?.backgroundColor = background_color
            
            if scZoom == nil {
                scZoom = UIScrollView()
                scZoom?.frame = UIScreen.main.bounds
                scZoom?.isUserInteractionEnabled = true
                viewZoomContainer?.addSubview(scZoom!)
            }
            
            if imgZoom == nil {
                imgZoom = UIImageView()
                imgZoom?.isUserInteractionEnabled = true
                
                if scZoom != nil {
                    scZoom?.addSubview(imgZoom!)
                    addPichZoom ()
                }
            }
            
            if btnRemoveZoomaContainer == nil {
                let frame = CGRect(x: 0.0, y: 10.0, width: 50, height: 50)
                btnRemoveZoomaContainer = UIButton(frame: frame)
                btnRemoveZoomaContainer?.setTitle("X", for: UIControlState.normal)
                btnRemoveZoomaContainer?.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                btnRemoveZoomaContainer?.setTitleColor(UIColor.white, for: UIControlState.normal)
                
                btnRemoveZoomaContainer?.addTarget(self, action: #selector(actionRemoveZoomContainer (_ :)), for: UIControlEvents.touchUpInside)
                
                viewZoomContainer?.addSubview(btnRemoveZoomaContainer!)
            }
        }
        
        DispatchQueue.main.async {
            let image = self.image
            
            if image != nil {
                
                self.imgZoom?.image = image
                
                let size = getImageSize((image?.size)!)
                
                var frame = self.imgZoom?.frame
                frame?.origin.x = (self.viewZoomContainer?.frame.size.width)! / 2 - size.width / 2
                frame?.origin.y = (self.viewZoomContainer?.frame.size.height)! / 2 - size.height / 2
                frame?.size.width = size.width
                frame?.size.height = size.height
                self.imgZoom?.frame = frame!
            }
        }
        
        superView?.addSubview(viewZoomContainer!)
    }
    
    @IBOutlet var scZoom: UIScrollView? = nil
    var viewZoomContainer: UIView? = nil
    var imgZoom: UIImageView? = nil
    var twoFingerPinch:UIPinchGestureRecognizer? = nil
    
    var superClass:Any? = nil
    
    @IBOutlet var btnRemoveZoomaContainer:UIButton? = nil
    
    @IBAction func actionRemoveZoomContainer(_ sender: Any) {
        viewZoomContainer?.removeFromSuperview()
    }
    
    func addPichZoom () {
        twoFingerPinch = UIPinchGestureRecognizer(target: self, action: #selector(self.twoFingerPinch(_ :)))
        imgZoom?.addGestureRecognizer(twoFingerPinch!)
    }
    
    func twoFingerPinch (_ recognizer:UIPinchGestureRecognizer) {
        let scale: CGFloat = recognizer.scale;
        imgZoom?.transform = (imgZoom?.transform.scaledBy(x: scale, y: scale))!;
        recognizer.scale = 1.0;
        
        var width = viewZoomContainer?.frame.size.width
        var height = viewZoomContainer?.frame.size.height
        
        if (imgZoom?.frame.size.width)! > (viewZoomContainer?.frame.size.width)! && (imgZoom?.frame.size.height)! > (viewZoomContainer?.frame.size.height)! {
            width = imgZoom?.frame.size.width
            height = imgZoom?.frame.size.height
        } else if (imgZoom?.frame.size.width)! > (viewZoomContainer?.frame.size.width)! {
            width = imgZoom?.frame.size.width
        } else if (imgZoom?.frame.size.height)! > (viewZoomContainer?.frame.size.height)! {
            height = imgZoom?.frame.size.height
        }
        
        scZoom?.contentSize = CGSize(width:width!, height:height!)
        
        imgZoom?.center = CGPoint(x: (scZoom?.contentSize.width)! / 2, y: (scZoom?.contentSize.height)! / 2)
        scZoom?.contentOffset = CGPoint(x: (imgZoom?.center.x)! - (scZoom?.frame.size.width)! / 2, y: (imgZoom?.center.y)! - (scZoom?.frame.size.height)! / 2)
    }
}








