//
//  ImageHelper.m
//  WarbyParker
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

#import "ImageHelper.h"

@implementation ImageHelper


#pragma mark - CGImage methods

+(CGImageRef) CGImageFromCIImage:(CIImage *)ciImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef img = [context createCGImage:ciImage fromRect:ciImage.extent];
    return img;
}


+ (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef degrees:(CGFloat)deg
{
    return [ImageHelper CGImageRotatedByAngle:imgRef angle:deg * (M_PI / 180)];
}

+ (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle
{
	CGFloat angleInRadians = angle;
    
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
    
	CGRect imgRect = CGRectMake(0, 0, width, height);
	CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
	CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmContext = CGBitmapContextCreate(NULL,
												   rotatedRect.size.width,
												   rotatedRect.size.height,
												   8,
												   0,
												   colorSpace,
												   kCGImageAlphaPremultipliedFirst);
	CGContextSetAllowsAntialiasing(bmContext, YES);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
	CGColorSpaceRelease(colorSpace);
	CGContextTranslateCTM(bmContext,
						  +(rotatedRect.size.width/2),
						  +(rotatedRect.size.height/2));
	CGContextRotateCTM(bmContext, angleInRadians);
	CGContextDrawImage(bmContext, CGRectMake(-width/2, -height/2, width, height),
					   imgRef);
    
	CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
	CFRelease(bmContext);
    
	return rotatedImage;
}

+(CGImageRef)compositeImage:(CGImageRef)image onto:(CGImageRef)background at:(CGRect)p
{
    return [ImageHelper compositeImage:image onto:background at:p releaseBackground:true];
}

+(CGImageRef)compositeImage:(CGImageRef)image onto:(CGImageRef)background at:(CGRect)p releaseBackground:(BOOL) releaseBackground
{
	CGContextRef cgcontext = CGBitmapContextCreate(nil, CGImageGetWidth(background), CGImageGetHeight(background), 8, CGImageGetBytesPerRow(background), 
                                                   CGColorSpaceCreateDeviceRGB(),
                                                   kCGImageAlphaNoneSkipFirst);
    CGRect bounds = CGRectMake(0, 0,CGImageGetWidth(background), CGImageGetHeight(background));
	
    CGContextDrawImage(cgcontext, bounds, background);
    CGContextSetBlendMode(cgcontext, kCGBlendModeSourceAtop);
    CGContextDrawImage(cgcontext, p, image);
    
    CGImageRef result = CGBitmapContextCreateImage(cgcontext);
    CGContextRelease(cgcontext);
    if(releaseBackground)
    {
        CGImageRelease(background);
    }
    return result;
}
#pragma mark - UIImage methods

+(UIImage *) imageFromCIImage:(CIImage *)ciImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    return [UIImage imageWithCGImage:[context createCGImage:ciImage fromRect:ciImage.extent]];
}

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize 
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *) imageFromView:(UIView *)v
{
	// Create the bitmap context
	UIGraphicsBeginImageContext(v.frame.size);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
    [v.layer renderInContext:bitmap];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+(UIImage *) flipImageClockWise:(UIImage *)image
{
    float radians = (90 * M_PI / 180.0f);
    
    // calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.height, image.size.width)];
	CGAffineTransform t = CGAffineTransformMakeRotation(radians);
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.height/2, rotatedSize.width/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, radians);
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.height, image.size.width), [image CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (UIImage *)rotateImage:(UIImage *)image byDegrees:(CGFloat)degrees 
{   
    return [ImageHelper rotateImage:image byRadians:(degrees * M_PI / 180)];
}

+ (UIImage *)rotateImage:(UIImage *)image byRadians:(CGFloat)radians 
{   
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(radians);
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, radians);
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
}


#pragma mark - CIImage methods
+(CIImage *) CIImageFromUIImage:(UIImage *)image
{
    return [CIImage imageWithCGImage:[image CGImage]];
}

+(CIImage *) rotatedCIImageFromUImage:(UIImage *)image
{
    
	CIImage * ciimage;
    if(image.size.height > image.size.width)
    {
        ciimage = [[[CIImage imageWithCGImage:[image CGImage]] imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI_2)] imageByApplyingTransform:CGAffineTransformMakeTranslation(0, image.size.height)];
    }
    else 
    {
        ciimage = [CIImage imageWithCGImage:[image CGImage]];
    }
    return ciimage;
}

+(CIImage *)scaleCIImage:(CIImage *)image toSize:(CGSize)size
{
    return [image imageByApplyingTransform:CGAffineTransformMakeScale(size.width / image.extent.size.width,size.height / image.extent.size.height)];
}

+(CIImage *) rotateCIImageClockwise:(CIImage *)image
{
    image = [[image imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI_2)] imageByApplyingTransform:CGAffineTransformMakeTranslation(0, image.extent.size.height)];
	return image;
}
@end
