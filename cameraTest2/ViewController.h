//
//  ViewController.h
//  cameraTest2
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController : UIViewController
{
@private
    AVCaptureDeviceInput* _videoIn;
    AVCaptureStillImageOutput* _imageOut;
    AVCaptureSession* _session;
    UIView* _preview;
}

@property (strong, nonatomic) AVCaptureDeviceInput* videoIn;
@property (strong, nonatomic) AVCaptureStillImageOutput* imageOut;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) UIView* preview;


@end
