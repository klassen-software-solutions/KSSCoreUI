//
//  MKMapViewExtension.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2019-03-08.
//  Copyright © 2019 Klassen Software Solutions. All rights reserved.
//

import MapKit

public extension MKMapView {
    /**
     scrollToCurrentLocation will obtain the user's current location and attempt to
     scroll that map to that position.
     */
    func scrollToCurrentLocation() {
        if isScrollEnabled {
            if let coord = userLocation.location?.coordinate{
                setCenter(coord, animated: true)
            }
        }
    }

    /**
     zoomIn zooms the map in approximately the same amount as a single click on
     the zoom controls. If zooming is not enabled, then this does nothing.
     */
    func zoomIn() {
        doZoom(0.5)
    }

    /**
     zoomOut zooms the map out approximately the same amount as a single click on
     the zoom controls. If zooming is not enabled, then this does nothing.
     */
    func zoomOut() {
        doZoom(2)
    }

    /**
     snapToNorth rotates the map, if necessary, in order to point it north. If already
     pointing north or if rotations are not enabled, then this does nothing.
     */
    func snapToNorth() {
        if isRotateEnabled && camera.heading != 0 {
            let c = MKMapCamera(lookingAtCenter: camera.centerCoordinate,
                                fromDistance: camera.altitude,
                                pitch: camera.pitch,
                                heading: 0)
            setCamera(c, animated: true)
        }
    }

    private func doZoom(_ factor: Double) {
        if isZoomEnabled {
            let r = region
            let s = MKCoordinateSpan(latitudeDelta: min(r.span.latitudeDelta * factor, 180),
                                     longitudeDelta: min(r.span.longitudeDelta * factor, 180))
            setRegion(MKCoordinateRegion(center: r.center, span: s), animated: true)

            // Most of the time snapToNorth will do nothing, since setRegion will have
            // already done this, but when rotated near the poles, and already zoomed out,
            // setRegion will do nothing. Hence we call this so that our result is
            // reasonably close to that of using the zoom controls.
            snapToNorth()
        }
    }
}
