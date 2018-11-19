//
//  ScanViewController.m
//  文俊购房
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    UIView *scanview;
}

//主要用来获取iphone一些关于相机设备的属性
@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,strong)UIImageView *scanimg;
@property (nonatomic,strong)NSTimer *timer;



@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"扫一扫" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    
    __weak UIViewController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };

    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    [_output setMetadataObjectsDelegate:self queue:(dispatch_get_main_queue())];
    
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    [_output setRectOfInterest:CGRectMake((124)/self.view.frame.size.height,((self.view.frame.size.width-220)/2)/self.view.frame.size.width,220/self.view.frame.size.height,220/self.view.frame.size.width)];
    
    [_session startRunning];
    
    CGFloat scanviewW = 250;
    CGFloat scanviewH = 250;
    CGFloat scanviewX = (self.view.frame.size.width - scanviewW) / 2;
    CGFloat scanviewY = (self.view.frame.size.height - scanviewH) / 2;
    scanview = [[UIView alloc]initWithFrame:(CGRect){scanviewX,scanviewY,scanviewW,scanviewH}];
    scanview.backgroundColor = [UIColor blackColor];
    scanview.alpha = 0.45;
    
    [self.view addSubview:scanview];
    
    _scanimg = [[UIImageView alloc]initWithFrame:(CGRect){0,0,scanviewW,12}];
    _scanimg.image = [UIImage imageNamed:@"扫描图片"];
    [scanview addSubview:_scanimg];
    
    [self addtimer];
}

-(void)addtimer{
    _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(scan) userInfo:nil repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:_timer forMode:NSRunLoopCommonModes];
}
//扫描动画
-(void)scan{
    CGFloat scanviewH = 250;
    [UIView animateWithDuration:1 animations:^{
        _scanimg.transform = CGAffineTransformTranslate(_scanimg.transform, 0, scanviewH);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _scanimg.transform = CGAffineTransformTranslate(_scanimg.transform, 0, -scanviewH);
        }];
    }];
}



#pragma mark AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        //停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        [self openScanBrowser:stringValue];
    }
}

//打开扫描到的二维码网站
-(void)openScanBrowser:(NSString *)str{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
}

@end
