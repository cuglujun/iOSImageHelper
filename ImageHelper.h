//
//  ImageHelper.h
//
//  Created by Michael on 7/16/12.
//  Copyright (c) 2012 happyMedium
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
enum {
    PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
    PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.  
    PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.  
    PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.  
    PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.  
    PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.  
    PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.  
    PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.  
};

@interface ImageHelper : NSObject

#pragma mark CGImage methods
+(CGImageRef) CGImageFromCIImage:(CIImage *)ciImage;
+ (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef degrees:(CGFloat)deg;
+ (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle;
+ (CGImageRef)compositeImage:(CGImageRef)image onto:(CGImageRef)background at:(CGRect)p;
+(CGImageRef)compositeImage:(CGImageRef)image onto:(CGImageRef)background at:(CGRect)p releaseBackground:(BOOL) releaseBackground;

#pragma mark UIImage methods
+(UIImage *) imageFromCIImage:(CIImage *)ciImage;
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize;
+ (UIImage *) imageFromView:(UIView *)v;
+ (UIImage *) flipImageClockWise:(UIImage *)image;
+ (UIImage *)rotateImage:(UIImage *)image byDegrees:(CGFloat)degrees;
+ (UIImage *)rotateImage:(UIImage *)image byRadians:(CGFloat)radians;

#pragma  mark CIImage methods
+ (CIImage *) CIImageFromUIImage:(UIImage *)image;
+ (CIImage *) rotatedCIImageFromUImage:(UIImage *)image;
+ (CIImage *) scaleCIImage:(CIImage *)image toSize:(CGSize)size;
+(CIImage *) rotateCIImageClockwise:(CIImage *)image;
@end
