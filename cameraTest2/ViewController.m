//
//  ViewController.m
//  cameraTest2
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize videoIn = _videoIn;
@synthesize imageOut = _imageOut;
@synthesize session = _session;
@synthesize preview = _preview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 撮影ボタンを配置したツールバーを生成
    UIToolbar* toolbar =
    [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    
    UIBarButtonItem* shootingPhotoButton =
    [[UIBarButtonItem alloc] initWithTitle:@"写真を取る"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(shootingPhotoAction:)];
    UIBarButtonItem* shootingPhotoButton2 =
    [[UIBarButtonItem alloc] initWithTitle:@"撮影"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(shootingPhotoAction:)];
    
    //toolbar.items = @[takePhotoButton];
    //ツールバーへボタンを登録する@[]で配列を用意している
    toolbar.items = @[shootingPhotoButton,shootingPhotoButton2];
    //現在のビューへツールバーを追加
    [self.view addSubview:toolbar];
    
    // プレビュー用のビューを生成
    self.preview =
    [[UIView alloc]
     initWithFrame:CGRectMake(0,
                              toolbar.frame.size.height,
                              self.view.bounds.size.width,
                              self.view.bounds.size.height - toolbar.frame.size.height)];

    //現在のビューに別のビューを追加する
    //プレビュー用のビューを設定（中身は後で設定する）
    [self.view addSubview:self.preview];
    
    // 撮影開始
    [self setupAVCapture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupAVCapture
{
    NSError *error = nil;
    
    // 画像取得の為にキャプチャーセッションを作成
    self.session = [[AVCaptureSession alloc] init];
    
    // 正面のカメラを使用する準備
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 準備を行ったカメラからの入力を作成し、キャプチャーセッションに追加
    self.videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    [self.session addInput:self.videoIn];
    
    // 画像への出力を作成し、キャプチャーセッションに追加
    self.imageOut = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.imageOut];
    
    // キャプチャーセッションから入力のプレビュー表示を作成
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer =
    [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    //レイヤーの大きさは現在の画面の矩形サイズ
    captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // レイヤーをプレビュー用のビューに設定
    CALayer *previewLayer = self.preview.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];
    
    // セッション開始
    [self.session startRunning];
    [self shootingPhoto];
}

- (void)shootingPhotoAction:(id)sender
{
    [self shootingPhoto];
}
- (void)shootingPhoto
{
    // ビデオ入力のAVCaptureConnectionを取得
    AVCaptureConnection *videoConnection =
    [self.imageOut connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection != nil)
    {
        
        // ビデオ入力から画像を非同期で取得。
        //定義されている処理が呼び出され、画像データを引数から取得する
        [self.imageOut
         captureStillImageAsynchronouslyFromConnection:videoConnection
         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
             if (imageDataSampleBuffer == NULL) {
                 return;
             }
             
             // 入力された画像データからJPEGフォーマットとしてデータを取得
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             
             // JPEGデータからUIImageを作成
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             
             // アルバムに画像を保存
             UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
         }];
    }
}

@end
