iOSImageHelper
==============

An iOS helper library to make creating/converting/compositing images a little easier.


This is a small collection of methods that make converting to/from CGImage, UIImage, and CIImage a little easier.
It also includes methods to rotate images arbitrary angles, compositing CGImages together, and composite a UIView (with subviews) into UIImages.

All methods are class methods, there isn't really any ImageHelper object.

CGImage Methods


    +(CGImageRef) CGImageFromCIImage:(CIImage *)ciImage;
    +(CGImageRef) CGImageRotatedByAngle:(CGImageRef)imgRef degrees:(CGFloat)deg;
    +(CGImageRef) CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle;
    +(CGImageRef) compositeImage:(CGImageRef)image onto:(CGImageRef)background at:(CGRect)p;		//releases background for you
    +(CGImageRef) compositeImage:(CGImageRef)image onto:(CGImageRef)background at:(CGRect)p releaseBackground:(BOOL) releaseBackground;
    
    
UIImage Methods

    +(UIImage *) imageFromCIImage:(CIImage *)ciImage;
    +(UIImage *) resizeImage:(UIImage *)image toSize:(CGSize)newSize;
    +(UIImage *) imageFromView:(UIView *)v;
    +(UIImage *) flipImageClockWise:(UIImage *)image;
    +(UIImage *) rotateImage:(UIImage *)image byDegrees:(CGFloat)degrees;
    +(UIImage *) rotateImage:(UIImage *)image byRadians:(CGFloat)radians;

CIImage Methods

    +(CIImage *) CIImageFromUIImage:(UIImage *)image;
    +(CIImage *) rotatedCIImageFromUImage:(UIImage *)image;
    +(CIImage *) scaleCIImage:(CIImage *)image toSize:(CGSize)size;
    +(CIImage *) rotateCIImageClockwise:(CIImage *)image;