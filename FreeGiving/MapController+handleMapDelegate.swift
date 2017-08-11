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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "gift")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation
        {
            return
        }

        guard let postsAnnotation = view.annotation as? Post else { return }
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.post = postsAnnotation
        calloutView.mapVC = self

//        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: calloutView.bounds.size.height * 0.52)
        //        mapView.setCenter((view.annotation?.coordinate)!, animated: true)

        view.addSubview(calloutView)
        
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
