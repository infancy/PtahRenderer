//
//  Geometry.swift
//  PtahRenderer
//
//  Created by Simon Rodriguez on 14/02/2016.
//  Copyright © 2016 Simon Rodriguez. All rights reserved.
//

import Foundation


/*--Barycentre-------*/

func barycentre(_ p: Point3, _ v0: Point3, _ v1: Point3, _ v2: Point3) -> Point3{

	let ab = v1 - v0
	let ac = v2 - v0
	let pa = v0 - p
	let uv1 = cross((ac.0, ab.0, pa.0), (ac.1, ab.1, pa.1))
	if abs(uv1.2) < 1e-2 {
		return (-1, 1, 1)
	}
	return (1.0-(uv1.0+uv1.1)/uv1.2, uv1.1/uv1.2, uv1.0/uv1.2)

}


func barycentricInterpolation(coeffs: Point3, t1: Point2, t2: Point2, t3: Point2) -> Point2{

	return (coeffs.0 * t1.0 + coeffs.1 * t2.0 + coeffs.2 * t3.0,
	        coeffs.0 * t1.1 + coeffs.1 * t2.1 + coeffs.2 * t3.1)

}


func barycentricInterpolation(coeffs: Point3, t1: Point3, t2: Point3, t3: Point3) -> Point3{

	return (coeffs.0 * t1.0 + coeffs.1 * t2.0 + coeffs.2 * t3.0,
	        coeffs.0 * t1.1 + coeffs.1 * t2.1 + coeffs.2 * t3.1,
	        coeffs.0 * t1.2 + coeffs.1 * t2.2 + coeffs.2 * t3.2)

}


func barycentricInterpolation(coeffs: Point3, t1: [Scalar], t2: [Scalar], t3: [Scalar]) -> [Scalar]{
	
	var newOthers : [Scalar] = []
	for i in 0..<t1.count {
		newOthers.append(coeffs.0 * t1[i] + coeffs.1 * t2[i] + coeffs.2 * t3[i])
	}
	return newOthers

}


/*--Bounding box-------------*/

func boundingBox(_ vs: [Point3], _ width: Int, _ height: Int) -> (Point2, Point2){
	
	var mini  = (Scalar.infinity, Scalar.infinity)
	var maxi = (-Scalar.infinity, -Scalar.infinity)
	let lim = (Scalar(width-1), Scalar(height-1))
	

	for v in vs {
		mini.0 = min(mini.0, v.0)
		mini.1 = min(mini.1, v.1)
		maxi.0 = max(maxi.0, v.0)
		maxi.1 = max(maxi.1, v.1)
	}
	
	let finalMinX = clamp(min(mini.0, maxi.0), 0, lim.0)
	let finalMinY = clamp(min(mini.1, maxi.1), 0, lim.1)
	let finalMaxX = clamp(max(mini.0, maxi.0), 0, lim.0)
	let finalMaxY = clamp(max(mini.1, maxi.1), 0, lim.1)
	
	return ((finalMinX, finalMinY), (finalMaxX, finalMaxY))
	
}