#import "WebViewController.h"
#import "WebViewJavascriptBridge.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "QRCodeViewController.h"
#import "HHBluetoothPrinterManager.h"
#import "BluetoothViewController.h"
#import "PrintModel.h"

@interface WebViewController()

@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIImageView *testView;
@property (nonatomic, strong) NSMutableArray *printDatas;
@property (nonatomic, strong) PrintModel *printModel;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *staffNo;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _printDatas = [NSMutableArray array];
    [NSTimer scheduledTimerWithTimeInterval:(float)0.02 target:self selector:@selector(sendDataTimer:) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    self.manager.delegate = self;
//    [self.manager cancelScan];
    
    if (_bridge) { return; }
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];

    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [self openScan];
    [self printFeeList];
//    [self printQrcode];
    [self logout];
//    [self renderButtons:webView];
    [self loadWebView:webView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)renderButtons:(UIWebView*)webView
{
    self.testView = [UIImageView new];
    self.testView.backgroundColor = [UIColor redColor];
    [self.view insertSubview:self.testView aboveSubview:webView];
    [self.testView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(100);
        make.width.height.equalTo(@200);
    }];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

#pragma mark - handler JSCall

- (void)openScan
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"openScan" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"openScan == %@", data);
//        responseCallback(@{ @"status":@"1" });
        if(data)
        {
            QRCodeViewController *vc = [[QRCodeViewController alloc]init];
            vc.scanResultBlock = ^(QRCodeViewController *vc, NSString *resultStr)
            {
                PLog(@"scan result == %@", resultStr);
                [vc.navigationController popViewControllerAnimated:NO];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:resultStr forKey:@"url"];
                
                // 方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
                [defaults synchronize];
                UIViewController *detailVc = [NSClassFromString(@"WebDetailViewController") new];
                [self.navigationController pushViewController:detailVc animated:YES];

//                UIImage * printimage = [self createQRForString:resultStr];
//                self.testView.image = printimage;
                //            [self png2GrayscaleImage:printimage];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)printFeeList
{
    [_bridge registerHandler:@"printFeeList" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"printFeeList == %@", data);
        if(data)
        {
            _printModel = [PrintModel mj_objectWithKeyValues:data];
            
            if([[HHBluetoothPrinterManager sharedManager] isConnectSuccess])
            {
//                self.view.userInteractionEnabled = NO;
//                [SVProgressHUD showWithStatus:@"打印中..."];
                [self printInit:FeeList];
//                [self print];
//                self.view.userInteractionEnabled = YES;
//                [SVProgressHUD showSuccessWithStatus:@"打印成功"];
            }
            else
            {
                BluetoothViewController *vc = [[BluetoothViewController alloc]init];
                vc.printerBlock = ^(BluetoothViewController *vc)
                {
                    [vc.navigationController popViewControllerAnimated:NO];
//                    self.view.userInteractionEnabled = NO;
                    [SVProgressHUD showInfoWithStatus:@"连接成功，开始打印"];
                    PLog(@"开始打印=====");
                    [self printInit:FeeList];
                    PLog(@"打印结束=====");
//                    self.view.userInteractionEnabled = YES;
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

- (void)printQrcode
{
    [_bridge registerHandler:@"printQrcode" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"printQrcode == %@", data);
        if(data)
        {
            self.orderNo = data[@"orderNo"];
            self.staffNo = data[@"staffNo"];
            if([[HHBluetoothPrinterManager sharedManager] isConnectSuccess])
            {
                _printModel = [PrintModel mj_objectWithKeyValues:data];
                [self printInit:QRCode];
            }
            else
            {
                BluetoothViewController *vc = [[BluetoothViewController alloc]init];
                vc.printerBlock = ^(BluetoothViewController *vc)
                {
                    [vc.navigationController popViewControllerAnimated:NO];
                    [SVProgressHUD showInfoWithStatus:@"连接成功，开始打印"];
//                    [self printQR];
                    [self printInit:QRCode];
                    [[HHBluetoothPrinterManager sharedManager] printTest:_printDatas];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

- (void)sendDataTimer:(NSTimer *)timer
{
    //发送打印数据
    //NSLog(@"send data timer");
    
    if ([_printDatas count] > 0)
    {
        NSData* cmdData;
        
        cmdData = [_printDatas objectAtIndex:0];
        [[HHBluetoothPrinterManager sharedManager] startPrint:cmdData];
        
        [_printDatas removeObjectAtIndex:0];
        PLog(@"print length == %ld", _printDatas.count);
    }
}

- (void)logout
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"logout" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"logout == %@", data);
        if(data)
        {
            [self cleanCacheAndCookie];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - creatQRImage

- (UIImage *)createQRForString:(NSString *)qrString {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data
              forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:0.1
                                   orientation:UIImageOrientationUp];
    
    // 不失真的放大
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:10.0];
    
    // 缩放到固定的宽度(高度与宽度一致)
    UIImage * endImage = [self scaleWithFixedWidth:400 image:resized];
    CGImageRelease(cgImage);
    return endImage;
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

- (UIImage *)scaleWithFixedWidth:(CGFloat)width image:(UIImage *)image
{
    float newHeight = image.size.height * (width / image.size.width);
    CGSize size = CGSizeMake(width, newHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}

#pragma mark - print

- (void)printInit:(PrintType)type
{
    [self printerInit];
    [self jingb];
    [self jinga];
    if(type == FeeList)
        [self printFeeListFormat];
    else
        [self printQRCodeFormat];
    [self printerInit];
}

- (void)printFeeListFormat
{
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"交易编号：%@\n", _printModel.orderNo]];
    
    for(OrderClothessModel *orderClothess in _printModel.orderClothess)
    {
        [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"联系人：%@\n", orderClothess.recvName]];
        [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"收件地址：%@%@%@%@\n", orderClothess.recvCity, orderClothess.recvArea, orderClothess.recvSecArea, orderClothess.recvAddress]];
        [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"是否加急：%@\n", orderClothess.isUrgent?@"是":@"否"]];
        [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    }
    
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"名称           数量        金额\n"];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    
//    FeesModel *f = [[FeesModel alloc]init];
//    f.clothesName = @"三个字";
//    f.quantity = @430;
//    f.amount = @300;
//    [_printModel.fees addObject:f];
//
//    FeesModel *f2 = [[FeesModel alloc]init];
//    f2.quantity = @43;
//    f2.amount = @300;
//    f2.clothesName = @"五个字个字";
//    [_printModel.fees addObject:f2];
    
    for(FeesModel *fee in _printModel.fees)
    {
        if(fee.clothesName.length == 2)
        {
            [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"%@            %@           %@\n", fee.clothesName, fee.quantity, fee.amount]];
        }
        else if(fee.clothesName.length == 3)
        {
            [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"%@         %@          %@\n", fee.clothesName, fee.quantity, fee.amount]];
        }
        else if(fee.clothesName.length == 4)
        {
            [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"%@        %@           %@\n", fee.clothesName, fee.quantity, fee.amount]];
        }
        else
        {
            [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"%@      %@          %@\n", fee.clothesName, fee.quantity, fee.amount]];
        }
    }
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"合计                        %@\n", _printModel.totalAmount]];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"折扣                        %@\n", _printModel.offsetAmount]];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"应收                        %@\n", _printModel.payAmount]];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"委托人签名：\n\n"];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"收件人签名：\n\n\n\n\n\n"];
}

- (void)printQRCodeFormat
{
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"广西兆泳\n"];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"收件员工号：%@\n\n\n", self.staffNo]];
//    UIImage * printimage = [self createQRForString:[NSString stringWithFormat:@"http://www.eyixi.com:8088/atake/app/order/goNextOrderStep.do?orderNo=%@\n\n", self.orderNo]];
    UIImage * printimage = [self createQRForString:@"https://www.baidu.com"];
//    [self appendImage:printimage maxWidth:250];
    [self png2GrayscaleImage:printimage];
//    [self appendQRCodeWithInfo:@"https://www.baidu.com"];
//    [self appendImage:[UIImage imageNamed:@"ico180"] maxWidth:300];
    [self printerWithFormat:Align_Center CharZoom:Char_Normal Content:self.orderNo];
}

- (UIImage *)png2GrayscaleImage:(UIImage *) oriImage
{
    //const int ALPHA = 0;
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    int width = oriImage.size.width ;//imageRect.size.width;
    int height =oriImage.size.height;
    int imgSize = width * height;
    int x_origin = 0;
    int y_to = height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(imgSize * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, imgSize * sizeof(uint32_t));
    
    NSInteger nWidthByteSize = (width+7)/8;
    
    NSInteger nBinaryImgDataSize = nWidthByteSize * y_to;
    Byte *binaryImgData = (Byte *)malloc(nBinaryImgDataSize);
    
    memset(binaryImgData, 0, nBinaryImgDataSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width , height), [oriImage CGImage]);
    
    Byte controlData[8];
    controlData[0] = 0x1d;
    controlData[1] = 0x76;//'v';
    controlData[2] = 0x30;
    controlData[3] = 0;
    controlData[4] = nWidthByteSize & 0xff;
    controlData[5] = (nWidthByteSize>>8) & 0xff;
    controlData[6] = y_to & 0xff;
    controlData[7] = (y_to>>8) & 0xff;
    NSData *printData = [[NSData alloc] initWithBytes:controlData length:8];
    [self printData:printData];
    
    for(int y = 0; y < y_to; y++)
    {
        for(int x = x_origin; x < width ; x++)
        {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            /*
             rgbaPixel[RED] = gray;
             rgbaPixel[GREEN] = gray;
             rgbaPixel[BLUE] = gray;
             */
            if (gray > 228)
            {
                rgbaPixel[RED] = 255;
                rgbaPixel[GREEN] = 255;
                rgbaPixel[BLUE] = 255;
                
            }
            else
            {
                rgbaPixel[RED] = 0;
                rgbaPixel[GREEN] = 0;
                rgbaPixel[BLUE] = 0;
                binaryImgData[(y*width+x)/8] |= (0x80>>(x%8));
            }
        }
    }
    
    printData = [[NSData alloc] initWithBytes:binaryImgData length:nBinaryImgDataSize];
    [self printData:printData];
    
    memset(controlData, '\n', 8);
    printData = [[NSData alloc] initWithBytes:controlData length:3];
    [self printData:printData];
    
    return 0;
}

- (void)printData:(NSData *)dataPrinted
{
    NSLog(@"print data:%lu", (unsigned long)[dataPrinted length]);
    //    aa++;
//#define MAX_CHARACTERISTIC_VALUE_SIZE 20
    NSData  *data    = nil;
    NSUInteger i;
    NSUInteger strLength;
    NSUInteger cellCount;
    NSUInteger cellMin;
    NSUInteger cellLen;
    
    NSLog(@"print data:%@", dataPrinted);
    
    
    strLength = [dataPrinted length];
    PLog(@"strlength == %ld", strLength);
    cellCount = (strLength%MAX_CHARACTERISTIC_VALUE_SIZE)?(strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    
    for (i=0; i<cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        
        NSLog(@"print:%lu,%lu,%lu,%lu", (unsigned long)strLength,(unsigned long)cellCount, (unsigned long)cellMin, (unsigned long)cellLen);
        NSRange rang = NSMakeRange(cellMin, cellLen);
        
        data = [dataPrinted subdataWithRange:rang];
        NSLog(@"print:%@", data);
        //        if (aa>3) {
        
        //        }else{
        [_printDatas addObject:data];
        //        }
        //        [manager startPrint:data];
    }
}

- (void)printerWithFormat:(Align_Type_e)eAlignType CharZoom:(Char_Zoom_Num_e)eCharZoomNum Content:(NSString *)printContent{
    NSData  *data    = nil;
    NSUInteger strLength;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    Byte caPrintFmt[500];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    //caPrintFmt[0] = 0x1b;
    //caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[0] = 0x1d;
    caPrintFmt[1] = 0x21;
    caPrintFmt[2] = (eCharZoomNum<<4) | eCharZoomNum;
    caPrintFmt[3] = 0x1b;
    caPrintFmt[4] = 0x61;
    caPrintFmt[5] = eAlignType;
    NSData *printData = [printContent dataUsingEncoding: enc];
    Byte *printByte = (Byte *)[printData bytes];
    
    strLength = [printData length];
    if (strLength < 1) {
        return;
    }
    
    for (int  i = 0; i<strLength; i++)
    {
        caPrintFmt[6+i] = *(printByte+i);
    }
    
    data = [NSData dataWithBytes:caPrintFmt length:6+strLength];
    
    [self printLongData:data];
}

- (void)printLongData:(NSData *)printContent
{
    NSUInteger i;
    NSUInteger strLength;
    NSUInteger cellCount;
    NSUInteger cellMin;
    NSUInteger cellLen;
    
    strLength = [printContent length];
    if (strLength < 1) {
        return;
    }
    
    cellCount = (strLength%MAX_CHARACTERISTIC_VALUE_SIZE)?(strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    for (i=0; i<cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        
        PLog(@"print:%d,%d,%d,%d", strLength,cellCount, cellMin, cellLen);
        NSRange rang = NSMakeRange(cellMin, cellLen);
        NSData *subData = [printContent subdataWithRange:rang];
        
        PLog(@"print:%@", subData);
        [_printDatas addObject:subData];
    }
}

- (void)jinga
{
    unsigned char* cData = (unsigned char *)calloc(100, sizeof(unsigned char));
    NSData* sendData = nil;
    //选中中文指令集
    cData[0] = 0x1b;
    cData[1] = 0x74;
    cData[2] = 15;
    sendData = [NSData dataWithBytes:cData length:3];
    
    free(cData);
    [_printDatas addObject:sendData];
    
}
- (void)jingb
{
    unsigned char* cData = (unsigned char *)calloc(100, sizeof(unsigned char));
    NSData* sendData = nil;
    //选中中文指令集
    cData[0] = 0x1c;
    cData[1] = 0x26;
    sendData = [NSData dataWithBytes:cData length:2];
    free(cData);
    [_printDatas addObject:sendData];
}

- (void)printerInit
{
    NSData *printFormat;
    Byte caPrintFmt[20];
    
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    printFormat = [NSData dataWithBytes:caPrintFmt length:2];
    PLog(@"format:%@", printFormat);
    
    [_printDatas addObject:printFormat];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    PLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    PLog(@"webViewDidFinishLoad");
}

- (void)loadWebView:(UIWebView*)webView
{
    NSURL* url = [NSURL URLWithString:@"http://www.e-yixi.com:8088/atake/app/order/orderPage.do"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

@end


