//
//  FilePresentationViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/3.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "FilePresentationViewController.h"
#include <objc/runtime.h>
#import <WebKit/WebKit.h>
#import "ReceiveTransactionService.h"
#import "SendFileService.h"
#import "FilePresentationCell.h"
#import "AttatchFileModel.h"
#import "FilePresentationHeader.h"
#import "MBProgressHUD+LCL.h"
#import "FilePreViewController.h"
#import "AttatchFileDownloader.h"
#import "URLConfiguration.h"
#import "WebViewContainerCell.h"
#import "DrawView.h"
#import "UIImage+EasyExtend.h"
#import <AFNetworking/AFNetworking.h>
#import "RequestManager.h"
#import "URLConfiguration.h"
#import "HandwriteModel.h"
#import "UIColor+Scheme.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <MJExtension/MJExtension.h>

static NSInteger handwriteImageViewTag = 99;
static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";
static NSString *const headerReuseIdentifier = @"headerReuseIdentifier";

@interface FilePresentationViewController()<UICollectionViewDataSource, WKNavigationDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, strong) NSArray<id<AttatchFileModel>> *files;
@property (strong, nonatomic) UICollectionView *fileCollectionView;
@property (strong, nonatomic) UICollectionView *webViewCollectionView;
@property (nonatomic, strong) NSString *mainGUID; //主表记录
@property (nonatomic, strong) id<FilePresentationViewModel> viewModel;

@property (nonatomic, strong) NSIndexPath *webCollectionIndexPath;
@property (nonatomic, weak) DrawView *drawView;
@property (nonatomic, strong) NSMutableArray<HandwriteModel*> *handwrites; //手写记录s

@end

@implementation FilePresentationViewController

- (void)dealloc {
    NSLog(@"%@ 被销毁 ♻️", NSStringFromClass(self.class));
}

- (instancetype)initWithViewModel:(id<FilePresentationViewModel>)viewModel
                         mainGuid:(NSString *)mainGUID
                        whereGUID:(NSString *)whereGUID {
    self = [self init];
    self.viewModel = viewModel;
    self.viewModel.mainGuid = mainGUID;
    self.viewModel.whereGuid = whereGUID;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _webCollectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.webViewCollectionView registerClass:[WebViewContainerCell class] forCellWithReuseIdentifier:@"WebViewContainerCell"];
    [self.fileCollectionView registerNib:[UINib nibWithNibName:@"FilePresentationCell" bundle:nil] forCellWithReuseIdentifier:cellReuseIdentifier];
    [self.fileCollectionView registerNib:[UINib nibWithNibName:@"FilePresentationHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier];
    self.fd_interactivePopDisabled = YES;
    [self _loadData];
}

#pragma mark - data flows
- (void)_loadData {
    @weakify(self);
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"加载中.." atView:self.view];
    RACSignal *attatchFileRequest = [self.viewModel requestAttatchFiles];
    RACSignal *requestRecord = [self.viewModel requestRecord];
    [[attatchFileRequest zipWith:requestRecord]
     subscribeNext:^(RACTuple *x) {
         @strongify(self);
         self.files = [x first];
         [self.fileCollectionView reloadData];
         [self.webViewCollectionView reloadData];
         self.viewModel.recordModel = [x second];
         [self _setNormalItems];
         WebViewContainerCell *cell = (WebViewContainerCell*)[self.webViewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         [self _loadCPBForCell:cell];
         [self loadHandwrittenRecords];
     } error:^(NSError * _Nullable error) {
        [hud showMessage:error.localizedDescription];
    } completed:^{
        [hud hideAnimated:YES];
    }];

}

- (void)loadHandwrittenRecords {
    @weakify(self);
    [[self.viewModel handwrittenRecords] subscribeNext:^(id x) {
        @strongify(self);
        if ([x isKindOfClass:[NSArray class]]) {
            [self.handwrites addObjectsFromArray:x];
        } else if ([x isKindOfClass:[HandwriteModel class]]) {
            [self.handwrites addObject:x];
        }
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        @strongify(self);
        [self _reloadHandWriteViews];
    }];
}

- (void)_loadCPBForCell:(WebViewContainerCell *)cell {
    WKWebView *webView = cell.preViewer.webView;
    [webView stopLoading];
    NSString *urlString = [self.viewModel cpbURLString];
    NSLog(@"🖥 加载:%@", urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [webView loadRequest:request];
}

#pragma mark - actions

- (void)touchAttatchFileAtButton:(UIButton *)sender {
    if (!sender) {
        return;
    }
    NSIndexPath *indexPath = (NSIndexPath *)objc_getAssociatedObject(sender, "indexPath");
    NSIndexPath *webIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    [self.webViewCollectionView setContentOffset:CGPointMake(webIndexPath.row*CGRectGetWidth(self.webViewCollectionView.frame), 0) animated:YES];
    self.webCollectionIndexPath = webIndexPath;
}

- (void)loadAttatchFileForCell:(WebViewContainerCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    
    id<AttatchFileModel> file = self.files[indexPath.row-1];
    cell.preViewer.fileModel = file;
  
    
}

- (void)openAttatchFile:(id<AttatchFileModel>)file forCell:(WebViewContainerCell *)cell {
    
}

// --------------------------   画板 --------------------------
- (void)_headerTouched:(id)sender {
    self.webCollectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.webViewCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)_clear:(id)sender {
    [_drawView clean];
}

- (void)_undo:(id)sender {
    [_drawView undo];
}

- (void)_changeModeWhenDrawing:(id)sender {
    UIScrollView *scrollView = self.drawView;
    if (scrollView.scrollEnabled) {
//        scrollView.scrollEnabled = false;
        self.navigationItem.rightBarButtonItems.lastObject.title = @"移动";
        self.drawView.scrollEnabled = false;
        self.drawView.maximumZoomScale = 1.0;
    } else {
//        scrollView.scrollEnabled = true;
        self.navigationItem.rightBarButtonItems.lastObject.title = @"手写";
        self.drawView.scrollEnabled = true;
        if (self.webCollectionIndexPath.row == 0) {
            self.drawView.maximumZoomScale = 5.0;
        } else {
            self.drawView.maximumZoomScale = 1.0; //只有呈批表放大没问题
        }
        
    }
}

- (void)_exit:(id)sender {
    [self.drawView removeFromSuperview];
    [self _setNormalItems];
    _fileCollectionView.userInteractionEnabled = YES;
    _webViewCollectionView.scrollEnabled = YES;
}

- (void)_save:(id)sender {
    //保存到服务器

    [self currentWebScrollView].zoomScale = 1.0;
    [self drawView].zoomScale = 1.0;
    
    CGRect referenceRect = self.drawView.referenceRect;
//    CGRect drawViewMinRect = self.drawView.thisMinRect;
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"上传中.." atView:nil];
    hud.mode = MBProgressHUDModeDeterminate;
    if (referenceRect.origin.x > 999) {
        [hud showMessage:@"没有任何手写记录！"];
        return;
    }

    WebViewContainerCell *cell = (WebViewContainerCell*)[self.webViewCollectionView cellForItemAtIndexPath:_webCollectionIndexPath];
    CGFloat scrollViewOffset = cell.preViewer.webView.scrollView.contentOffset.y;
    
    UIImage *saveImage = [UIImage imageWithView:_drawView];
    UIImage *clipImage = [saveImage clipWithRect:referenceRect];
    NSData *pngData = UIImagePNGRepresentation(clipImage);
    
    if (_webCollectionIndexPath.row != 0) {
        NSURL *fileURL = cell.preViewer.fileURL;
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        CGRect trueRect = CGRectMake(referenceRect.origin.x, referenceRect.origin.y+scrollViewOffset, referenceRect.size.width, referenceRect.size.height);
        [self addSignature:clipImage atRect:trueRect onPDF:data toPath:fileURL.path];
        cell.preViewer.fileURL = fileURL; //重设URL，以加载这个页面
        [cell.preViewer saveFileToServer];
        [self _exit:nil]; //退出编辑模式
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self currentWebScrollView] setContentOffset:CGPointMake(0, scrollViewOffset) animated:true];
        });
        
        return;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect referenceRect = self.drawView.referenceRect;
        NSDictionary *params = @{@"ActiveCode":[RequestManager shared].activeCode,
                                 @"Where_GUID":self.viewModel.whereGuid,
                                 @"CoordinateX":[@((NSInteger)referenceRect.origin.x) description],
                                 @"CoordinateY": [@((NSInteger)referenceRect.origin.y) description]};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
        NSString *jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *wrap = @{@"Action": [self.viewModel uploadCPBAction],
                               @"jsonRequest": jsonString};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        NSMutableSet *newAcceptContentTypes = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
        //扩展固定解析响应类型
        [newAcceptContentTypes addObjectsFromArray:@[@"text/plain"]];
        responseSerializer.acceptableContentTypes = newAcceptContentTypes;
        manager.responseSerializer = responseSerializer;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *fileName = [self.viewModel.whereGuid stringByAppendingPathExtension:@"png"];
        
        if (!pngData) {
            [hud showMessage:@"没有记录"];
            return;
        }
        @weakify(self);
        [manager POST:[self.viewModel uploadCPBURL] parameters:wrap constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:pngData name:self.viewModel.whereGuid fileName:fileName mimeType:@"media/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.progress = uploadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, NSData *responseObject) {
            @strongify(self);
            NSDictionary *jsonObject = [responseObject mj_JSONObject];
            NSLog(@"%@", [jsonObject mj_JSONString]);
            if ([jsonObject[@"IsSuccess"] boolValue]) {
                [hud showMessage:@"手写记录已经保存！✍️"];
            } else {
                [hud showMessage:jsonObject[@"ErrorMessage"]];
            }
            
            // 添加一条自己的记录
            HandwriteModel *model = [HandwriteModel new];
            model.origin = CGPointMake(referenceRect.origin.x, referenceRect.origin.y + scrollViewOffset);
            model.pngData = pngData;
            model.recordIdentifier = self.viewModel.whereGuid;
            [self.handwrites addObject:model];
            [self _reloadHandWriteViews];
            [self _exit:nil]; //退出编辑模式
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud showMessage:error.localizedDescription];
        }];
    });
}

// 手写按钮
- (void)_handWrite:(id)sender {
    if (_webCollectionIndexPath.row == 0) {
        HandwriteModel *myHandwrite = nil;
        for (HandwriteModel *iter in self.handwrites) {
            if ([iter.recordIdentifier isEqualToString:self.viewModel.whereGuid]) {
                myHandwrite = iter;
                break;
            }
        }
        
        if (myHandwrite) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到您已经有手写记录，进入手写将会清空之前的记录，确认吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.handwrites removeObject:myHandwrite];
                [self _reloadHandWriteViews];
                [self _setDrawingMode];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self _setDrawingMode];
        }
        
    } else if ([self.files[_webCollectionIndexPath.row-1].name.lowercaseString hasSuffix:@"pdf"]) { //PDF文件
        [self _setDrawingMode];
    }
    else {
        // 打开SDK WPS处理附件
        WebViewContainerCell *cell = (WebViewContainerCell *)[_webViewCollectionView cellForItemAtIndexPath:_webCollectionIndexPath];
        if(![cell.preViewer openWPS]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            [hud showMessage:@"下载中， 请稍后"];
        }
    }
}

#pragma mark - views

- (UIScrollView *)currentWebScrollView {
    WebViewContainerCell *cell = (WebViewContainerCell *)[_webViewCollectionView cellForItemAtIndexPath:_webCollectionIndexPath];
    UIScrollView *scrollView = cell.preViewer.webView.scrollView;
    return scrollView;
}

- (void)_setDrawingMode {
    
    UIScrollView *scrollView = [self currentWebScrollView];
    
    if (scrollView.contentSize.height == 0) {
        MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"加载中" atView:nil];
        [hud showMessage:@"无法进入手写模式"];
        return;
    }
    //呈现表 PDF
    DrawView *dw = [[DrawView alloc] initWithFrame:CGRectZero];
    scrollView.delegate = self;

    [self.view addSubview:dw];
    dw.frame = _webViewCollectionView.frame;
    dw.backgroundColor = [UIColor clearColor];
    dw.chainableScrollView = scrollView;
    dw.scrollEnabled = false;
    
    if (_webCollectionIndexPath.row != 0) {
        dw.zoomScale = 1.0;
        scrollView.zoomScale = 1.0;
        dw.maximumZoomScale = 1.0; //默认不能放大
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dw.originalOffset = scrollView.contentOffset.y;
        });
        
    } else {
        // 呈批表，可放大
//        dw.internal.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, dw.frame.size.width, dw.frame.size.height);
        dw.contentSize = scrollView.contentSize;
        dw.originalOffset = 0;
        dw.internal.frame = CGRectMake(0, 0, scrollView.contentSize.width/scrollView.zoomScale, scrollView.contentSize.height/scrollView.zoomScale);
        dw.maximumZoomScale = 5.0;
        dw.zoomScale = scrollView.zoomScale;
        dw.contentOffset = scrollView.contentOffset;
    }
    
    [dw setLineColor:[UIColor darkTextColor]];
    [dw setLineWidth:3.0];
    

    _drawView = dw;
    _fileCollectionView.userInteractionEnabled = NO;
//    _webViewCollectionView.scrollEnabled = false;
    [self _setEditingItems];
}

- (void)_setNormalItems
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBack.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btnBack setImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
    [btnBack sizeToFit];
    btnBack.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItems:@[back] animated:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setTitle:@"手写" forState:0];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(_handWrite:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *handWrite = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItems:@[handWrite] animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_setEditingItems {
    
    // left
    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnClear setTintColor:[UIColor whiteColor]];
    [btnClear setTitle:@"清空" forState:0];
    [btnClear.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btnClear sizeToFit];
    [btnClear addTarget:self action:@selector(_clear:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithCustomView:btnClear];
    
    UIButton *btnUndo = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnUndo setTintColor:[UIColor whiteColor]];
    [btnUndo setTitle:@"撤销" forState:0];
    [btnUndo.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btnUndo sizeToFit];
    [btnUndo addTarget:self action:@selector(_undo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *undo = [[UIBarButtonItem alloc] initWithCustomView:btnUndo];

    [self.navigationItem setLeftBarButtonItems:@[clear, undo] animated:YES];
    
    //right
    UIButton *btnExit = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnExit setTintColor:[UIColor whiteColor]];
    [btnExit setTitle:@"退出" forState:0];
    [btnExit.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btnExit sizeToFit];
    [btnExit addTarget:self action:@selector(_exit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *exit = [[UIBarButtonItem alloc] initWithCustomView:btnExit];

    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnSave setTintColor:[UIColor whiteColor]];
    [btnSave setTitle:@"保存" forState:0];
    [btnSave.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btnSave sizeToFit];
    [btnSave addTarget:self action:@selector(_save:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    UIButton *btnMove = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnMove setTintColor:[UIColor whiteColor]];
    [btnMove setTitle:@"移动" forState:0];
    [btnMove.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btnMove sizeToFit];
    [btnMove addTarget:self action:@selector(_changeModeWhenDrawing:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *move = [[UIBarButtonItem alloc] initWithCustomView:btnMove];
    
    NSMutableArray *items = [NSMutableArray arrayWithObjects:exit,save, nil];
    if (self.webCollectionIndexPath.row == 0) {
        [items addObject:move];
    }
    [self.navigationItem setRightBarButtonItems:items animated:YES];
}

- (void)_reloadHandWriteViews
{
    WebViewContainerCell *cell = (WebViewContainerCell*)[self.webViewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    for (UIView *v in cell.preViewer.webView.scrollView.subviews[0].subviews) {
        if (v.tag == handwriteImageViewTag) [v removeFromSuperview];
    }
    
    for (HandwriteModel *m in self.handwrites) {
        UIImage *img = [UIImage imageWithData:m.pngData];
        CGRect frame = CGRectMake(m.origin.x, m.origin.y, img.size.width, img.size.height);
        UIImageView *imv = [[UIImageView alloc] initWithFrame:frame];
        imv.image = img;
        imv.tag = handwriteImageViewTag;
        [cell.preViewer.webView.scrollView.subviews[0] addSubview:imv]; //必须要加载WKContentView上面，不然不会跟随放大
    }
    
    
}

// 添加PNG图片签名到PDF文件中去
- (void)addSignature:(UIImage *)imageSignature atRect:(CGRect)imageRect onPDF:(NSData *)pdfData toPath:(NSString *)outputPath {
    // 创建接收输出的对象
    NSMutableData *outputData = [NSMutableData new];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputData);
    CFMutableDictionaryRef attributes = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attributes, kCGPDFContextTitle, CFSTR("My Doc"));
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, attributes);
    CFRelease(dataConsumer);
    CFRelease(attributes);
    CGRect pageRect;
    
    
    // 创建documentRef
    CFDataRef dataRef = (__bridge CFDataRef) [pdfData copy];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(dataRef);
    CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithProvider(provider);
    
    CGDataProviderRelease(provider);
    
    CGRect pageRectOnScreen;
    // 计算宽度置当前屏幕宽度-边距（目前测量出来是8）；然后调整图片的宽高

    CGFloat pageWidth = CGRectGetWidth(self.view.frame)-16;
    
    
    
    //  显示的每一页之间的间距大约为5个像素点, 计算签名的位置在第几页
    NSInteger signaturePage = 1;
    
    // 重绘制PDF；
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(documentRef);
    for (size_t i = 1; i <= numberOfPages; i++) { //PDF从1开始
        CGPDFPageRef page = CGPDFDocumentGetPage(documentRef, i);
        pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        if (i == 1) {
            //屏幕上的PDF文件
            pageRectOnScreen = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), pageRect.size.height/pageRect.size.width*pageWidth+10);
            signaturePage = (NSInteger)(imageRect.origin.y/(pageRectOnScreen.size.height)) + 1;
        }
        CGContextBeginPage(pdfContext, &pageRect);
        CGContextDrawPDFPage(pdfContext, page);
        if (i == signaturePage) {
            CGFloat ratio = pageWidth / pageRect.size.width;
            CGFloat signatureY = pageRect.size.height - (imageRect.origin.y - (signaturePage-1) * pageRectOnScreen.size.height + imageRect.size.height)/ratio; //绘制的坐标系是左下角
            imageRect =  CGRectMake(imageRect.origin.x/ratio, signatureY, imageRect.size.width/ratio, imageRect.size.height/ratio);
            CGImageRef imageRef = [imageSignature CGImage];
            CGContextDrawImage(pdfContext, imageRect, imageRef);
//            CGImageRelease(imageRef);
        }

        CGPDFContextEndPage(pdfContext);
//        CGPDFPageRelease(page);
    }
    
    CGPDFContextClose(pdfContext);
    CGContextRelease(pdfContext);
    
     [outputData writeToFile:outputPath atomically:YES];

}

#pragma mark - collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _fileCollectionView) {
        if (self.files.count) {
            return self.files.count;
        } else {
            return 0;
        }
    } else {
        return 1 + self.files.count; //第一个是呈现表
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _fileCollectionView) {
        FilePresentationHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        UIButton *button = [header viewWithTag:1];
        [button addTarget:self
                   action:@selector(_headerTouched:)
         forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [header viewWithTag:3];
        if (_webCollectionIndexPath.row == 0) {
            label.textColor = [UIColor naviColor] ;
        } else {
            label.textColor = [UIColor darkGrayColor];
        }
        return header;
    } else {
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _fileCollectionView) {
        FilePresentationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
        UIButton *button =  cell.titleButton;
        id<AttatchFileModel> file = self.files[indexPath.row];
        [button setTitle:file.name forState:0];
        NSInteger selectedIndex = _webCollectionIndexPath.row - 1;
        if (indexPath.row == selectedIndex) {
            [button setTitleColor:[UIColor naviColor] forState:0];
        } else {
            [button setTitleColor:[UIColor darkGrayColor] forState:0];
        }
        
        objc_setAssociatedObject(button, "indexPath", indexPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [button addTarget:self action:@selector(touchAttatchFileAtButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        WebViewContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WebViewContainerCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.preViewer.autoScale = YES;
            cell.preViewer.fileURL = nil;
            [self _loadCPBForCell:cell];
        } else {
            id<AttatchFileModel> file = self.files[indexPath.row-1];
//            NSURL *fileURL = [[AttatchFileDownloader shared] cacheURLForFileName:file.name];
            cell.preViewer.viewModel = [[self.viewModel previewViewModelClass] new];
            cell.preViewer.viewModel.recordIdentifier = self.viewModel.mainGuid;
            [self loadAttatchFileForCell:cell forIndexPath:indexPath];
        }
        cell.preViewer.webView.scrollView.delegate = self;
        return cell;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_fileCollectionView == collectionView) {
        return CGSizeMake(250, 50.0);
    } else {
        return self.webViewCollectionView.frame.size;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (_fileCollectionView == collectionView) {
        return CGSizeMake(133.0, 50.0);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - scroll view



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _webViewCollectionView) {
        NSInteger index = (scrollView.contentOffset.x+10)/CGRectGetWidth(self.webViewCollectionView.frame);
        NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index inSection:0];
        NSInteger scrollIndex = 0;
        if (_webCollectionIndexPath.row >= index) {
            //往后
            scrollIndex = index-1;
        } else {
            scrollIndex = index;
        }
        self.webCollectionIndexPath = indexPath;
        [self.fileCollectionView scrollRectToVisible:CGRectMake(250*scrollIndex, 0, 300, 50) animated:YES];
    }
    
}



#pragma mark - webkit webview navigations


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}



#pragma mark - getters and setters

- (UICollectionView *)fileCollectionView {
    if (!_fileCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _fileCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _fileCollectionView.delegate = self;
        _fileCollectionView.dataSource = self;
        _fileCollectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_fileCollectionView];
        
        [_fileCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide).with.offset(0);
            make.left.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
            make.height.mas_equalTo(@62);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fileCollectionView.mas_bottom).with.offset(1);
            make.left.equalTo(self.fileCollectionView);
            make.right.equalTo(self.fileCollectionView);
            make.height.equalTo(@1);
        }];
    }
    return _fileCollectionView;
}

- (UICollectionView *)webViewCollectionView {
    if (!_webViewCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _webViewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _webViewCollectionView.delegate = self;
        _webViewCollectionView.dataSource = self;
        _webViewCollectionView.backgroundColor = [UIColor whiteColor];
        _webViewCollectionView.pagingEnabled = YES;
        [self.view addSubview:_webViewCollectionView];
        [_webViewCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fileCollectionView.mas_bottom).with.offset(0);
            make.left.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
            make.bottom.mas_equalTo(@0);
        }];
    }
    return _webViewCollectionView;
}

- (NSMutableArray<HandwriteModel *> *)handwrites {
    if (!_handwrites) {
        _handwrites = [NSMutableArray array];
    }
    return _handwrites;
}


- (void)setWebCollectionIndexPath:(NSIndexPath *)webCollectionIndexPath {
    _webCollectionIndexPath = webCollectionIndexPath;
    [self.fileCollectionView reloadData];
    
}


@end
