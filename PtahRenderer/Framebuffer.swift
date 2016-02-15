//
//  Framebuffer.swift
//  PtahRenderer
//
//  Created by Simon Rodriguez on 14/02/2016.
//  Copyright © 2016 Simon Rodriguez. All rights reserved.
//

import Foundation
import Cocoa

class Framebuffer {
	internal var pixels : [Pixel] = []
	internal var zbuffer : [Scalar] = []
	private var width : Int = 512
	private var height : Int = 512
	
	init(width _width : Int,height _height : Int){
		pixels = [Pixel](count: width*height, repeatedValue: Pixel(0))
		zbuffer = [Scalar](count: width*height, repeatedValue: -Scalar.infinity)
	}
	
	func set(x : Int,_ y : Int,_ color : Color){
		if(x < width && y < height && x >= 0 && y >= 0){
			pixels[y * width + x].rgb = color
		}
	}
	
	func set(x : Int,_ y : Int,_ color : Pixel){
		if(x < width && y < height && x >= 0 && y >= 0){
			pixels[y * width + x] = color
		}
	}
	
	func swapPixelBuffer(){
		let half = height >> 1
		for y in 0..<half {
			swap(&(pixels[y*width..<(y+1)*width]),&(pixels[width*(height-y-1)..<width*(height-y)]))
		}
	}
	
	/*--Utilities----------------------------------------------*/
	/*Courtesy of Simon Gladman, http://flexmonkey.blogspot.fr */
	/*---------------------------------------------------------*/
	
	private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
	private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
	
	internal func imageFromRGBA32Bitmap() -> NSImage {
		let bitsPerComponent:Int = 8
		let bitsPerPixel:Int = 32
		assert(pixels.count == Int(width * height))
		var data = pixels // Copy to mutable []
		let providerRef = CGDataProviderCreateWithCFData(NSData(bytes: &data, length: data.count * sizeof(Pixel)))
		
		let cgim = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, width * Int(sizeof(Pixel)), rgbColorSpace, bitmapInfo, providerRef, nil, true, .RenderingIntentDefault)
		return NSImage(CGImage: cgim!, size: NSSize(width: width, height: height))
	}
	
	internal func dumpZbuffer(){
		
		print(zbuffer.filter({$0 > -10.0}).sort().last)
	}
}