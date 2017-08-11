//
//  File.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/10.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

// Display the annotationView and the following handling

import MapKit
import SDWebImage

extension MapController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation
        {
            return
        }

        guard let postsAnnotation = view.annotation as? Post else { return }
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.post = postsAnnotation
        calloutView.starbucksName.text = postsAnnotation.title
        calloutView.starbucksAddress.text = postsAnnotation.productOnShelfTime
        calloutView.starbucksPhone.text = postsAnnotation.productDescription
        
        //
        let button = UIButton(frame: calloutView.starbucksPhone.frame)
//        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        
        calloutView.starbucksImage.sd_setImage(with: URL(string: postsAnnotation.productImageURL!), placeholderImage: nil)

        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: calloutView.bounds.size.height * 0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
}
