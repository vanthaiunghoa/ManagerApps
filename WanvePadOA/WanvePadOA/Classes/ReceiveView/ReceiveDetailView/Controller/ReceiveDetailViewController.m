#import "ReceiveDetailViewController.h"
#import "iAppOffice.h"

@interface ReceiveDetailViewController()

@property (strong, nonatomic) NSMutableDictionary *rightsMtbDict;
@property (strong, nonatomic) NSMutableArray *fileRightsMtbArr;

@end

@implementation ReceiveDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initDatas];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)initView
{
    UIButton *btn = [UIButton new];
    [btn setFrame:CGRectMake(100, 100, 50, 30)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"word" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clicked:(UIButton *)button
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        BOOL isSave = [self saveRightsToDocumentWithKey:iAppOfficeRightsPublicIsEditEnable value:iAppOfficeRightsBoolValueYES];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSave) {
//                NSString *fileNmaeStr = [self.fileNames objectAtIndex:indexPath.row];
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"WPSDocumentNotification" object:fileNmaeStr];
            }
            else {

                PLog(@"保存失败");
            }
        });
    });
}

#pragma mark - Pvivate

- (void)initDatas {

    self.rightsMtbDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self rightsFileFromDocuments]];
    self.fileRightsMtbArr = [NSMutableArray array];

    NSMutableDictionary *publicMtbDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Public", @"Name", [self.rightsMtbDict objectForKey:@"Public"], @"Rights", nil];
    [self.fileRightsMtbArr addObject:publicMtbDict];
    NSMutableDictionary *fileRightsMtbDict = [NSMutableDictionary dictionary];
    if (self.documentsType == KGWPSDocumentsTypeWord) {

        [fileRightsMtbDict setObject:@"Word" forKey:@"Name"];
        [fileRightsMtbDict setObject:[self.rightsMtbDict objectForKey:@"Word"] forKey:@"Rights"];
    }
    else if (self.documentsType == KGWPSDocumentsTypeExcel) {

        [fileRightsMtbDict setObject:@"Excel" forKey:@"Name"];
        [fileRightsMtbDict setObject:[self.rightsMtbDict objectForKey:@"Excel"] forKey:@"Rights"];
    }
    else if (self.documentsType == KGWPSDocumentsTypePPT) {

        [fileRightsMtbDict setObject:@"PPT" forKey:@"Name"];
        [fileRightsMtbDict setObject:[self.rightsMtbDict objectForKey:@"PPT"] forKey:@"Rights"];
    }
    else if (self.documentsType == KGWPSDocumentsTypePDF) {

        [fileRightsMtbDict setObject:@"PDF" forKey:@"Name"];
        [fileRightsMtbDict setObject:[self.rightsMtbDict objectForKey:@"PDF"] forKey:@"Rights"];
    }
    else {

        return;
    }
    [self.fileRightsMtbArr addObject:fileRightsMtbDict];
}

/*
 * 作者：段奕滨
 * 日期：2015-04-07
 * 功能：从沙盒中获取权限文档路径
 */
- (NSString *)rightsFileFromDocuments {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];

    NSString *rightsFilePath = [path stringByAppendingPathComponent:@"Settings/iAppOfficeRightsSetting.plist"];
    PLog(@"rightsFilePath == %@", rightsFilePath);
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:rightsFilePath];
    PLog(@"dict == %@", dict);
    if ([[NSFileManager defaultManager] fileExistsAtPath:rightsFilePath]) {

        return rightsFilePath;
    }
    else {

        return [self createSettingFile];
    }
}

/*
 * 作者：段奕滨
 * 日期：2015-04-03
 * 功能：创建设置文档
 */
- (NSString *)createSettingFile {

    //设置字典
    NSMutableDictionary *settingFileMtbDict = [NSMutableDictionary dictionary];

    //公共权限字典
    NSMutableDictionary *publicMtbDict = [NSMutableDictionary dictionary];
    [publicMtbDict setObject:@"公共权限" forKey:@"Name"];
    //公共权限键值
    NSMutableArray *publicRightsMtbArr = [NSMutableArray array];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否自动备份" note:@"" key:iAppOfficeRightsPublicIsBackup value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否显示水印" note:@"" key:iAppOfficeRightsPublicIsWatermark value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"自动备份间隔时间" note:@"如果打开了自动备份，必须设置该字段，关闭自动备份的情况下可以忽略该字段，该字段单位为秒，建议设置>=120的数值" key:iAppOfficeRightsPublicBackupInterval value:@"120" available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以分享" note:@"" key:iAppOfficeRightsPublicIsShare value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以打印" note:@"" key:iAppOfficeRightsPublicIsPrint value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以发送邮件" note:@"" key:iAppOfficeRightsPublicIsSendMail value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以导出为PDF" note:@"" key:iAppOfficeRightsPublicIsExportPDF value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以另存" note:@"" key:iAppOfficeRightsPublicIsSaveAs value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以本地保留" note:@"" key:iAppOfficeRightsPublicIsLocalization value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以编辑" note:@"" key:iAppOfficeRightsPublicIsEditEnable value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否以编辑模式打开" note:@"" key:iAppOfficeRightsPublicIsOpenInEditMode value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以插入手写墨迹" note:@"" key:iAppOfficeRightsPublicIsHandwritingLnk value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以无线投影" note:@"" key:iAppOfficeRightsPPTIsWirelessProjection value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以使用词典" note:@"" key:iAppOfficeRightsPublicIsDictionary value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以使用插线投影" note:@"" key:iAppOfficeRightsPublicIsWireProjection value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以复制" note:@"" key:iAppOfficeRightsPublicIsCopyEnable value:iAppOfficeRightsBoolValueNO available:YES]];
    [publicRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以截图" note:@"" key:iAppOfficeRightsPublicIsScreenCapture value:iAppOfficeRightsBoolValueNO available:YES]];

    [publicMtbDict setObject:publicRightsMtbArr forKey:@"Rights"];

    //Word文档权限
    NSMutableDictionary *wordMtbDict = [NSMutableDictionary dictionary];
    [wordMtbDict setObject:@"Word文档权限" forKey:@"Name"];

    NSMutableArray *wordRightsMtbArr = [NSMutableArray array];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"编辑模式下是否可以插入图片" note:@"" key:iAppOfficeRightsWordEditModeIsInsertPicture value:iAppOfficeRightsBoolValueNO available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"编辑模式下修订按钮是否打开" note:@"" key:iAppOfficeRightsWordEditModeIsRevision value:iAppOfficeRightsBoolValueNO available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"编辑模式下显示修订和标记按钮是否打开" note:@"如果默认以阅读模式打开文档，该字段无效，将取“阅读模式下显示修订与标记按钮是否打开”的值来设置开关是否打开" key:iAppOfficeRightsWordEditModeIsMark value:@"0" available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"编辑模式下是否可以切换修订按钮" note:@"如果不可切换，则退出修订，按钮也不可点" key:iAppOfficeRightsWordEditModeIsRevisionEnable value:@"0" available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"编辑模式下是否可以切换标记按钮" note:@"" key:iAppOfficeRightsWordEditModeIsMarkEnable value:@"0" available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"阅读模式下显示修订与标记按钮是否打开" note:@"如果默认以编辑模式打开文档，该字段无效，将取“编辑模式下显示修订和标记按钮是否打开”的值来设置开关是否打开" key:iAppOfficeRightsWordReadModeIsRevision value:@"0" available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"阅读模式下是否可以添加批注" note:@"如果默认打开是阅读模式，并且模式不能切换即“是否可以编辑”值为NO的时候这种情况属于只读，该值会强制设成NO，即不能添加批注" key:iAppOfficeRightsWordReadModeIsAddCommentEnable value:iAppOfficeRightsBoolValueNO available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"阅读模式下是否可以编辑批注" note:@"如果默认打开是阅读模式，并且模式不能切换即“是否可以编辑”值为NO的时候这种情况属于只读，该值会强制设成NO，即不能编辑批注" key:iAppOfficeRightsWordReadModeIsCommentEditEnable value:iAppOfficeRightsBoolValueNO available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"阅读模式下是否可以复制" note:@"已废弃，使用“公共权限中的‘复制’”代替" key:iAppOfficeRightsWordReadModeIsCopyEnable value:iAppOfficeRightsBoolValueNO available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以导出为PDF" note:@"已废弃，使用“公共权限中的‘导出为PDF’”代替" key:iAppOfficeRightsWordIsExportPDF value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以发送邮件" note:@"已废弃，使用“公共权限中的‘发送邮件’”代替" key:iAppOfficeRightsWordIsSendMail value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以分享" note:@"已废弃，使用“公共权限中的‘分享’”代替" key:iAppOfficeRightsWordIsShare value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以打印" note:@"已废弃，使用“公共权限中的‘打印’”代替" key:iAppOfficeRightsWordIsPrint value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以本地保留" note:@"已废弃，使用“公共权限中的‘本地保留’”代替" key:iAppOfficeRightsWordIsLocalization value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否以编辑模式打开" note:@"已废弃，使用“公共权限中的‘以编辑模式打开’”代替" key:iAppOfficeRightsWordIsOpenInEditMode value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以另存" note:@"已废弃，使用“公共权限中的‘另存’”代替" key:iAppOfficeRightsWordIsSaveAs value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"修订用户名" note:@"" key:iAppOfficeRightsWordRevisionUserName value:@"admin" available:YES]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以无线投影" note:@"已废弃，使用“公共权限中的‘无线投影’”代替" key:iAppOfficeRightsWordIsWireless value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以编辑" note:@"已废弃，使用“公共权限中的‘编辑’”代替" key:iAppOfficeRightsWordIsEditMode value:iAppOfficeRightsBoolValueNO available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以插入手写墨迹" note:@"已废弃，使用“公共权限中的‘插入手写墨迹’”代替" key:iAppOfficeRightsWordIsHandwritingLnk value:iAppOfficeRightsBoolValueNO available:NO]];

    [wordMtbDict setObject:wordRightsMtbArr forKey:@"Rights"];


    //Excel文档权限
    NSMutableDictionary *excelMtbDict = [NSMutableDictionary dictionary];
    [excelMtbDict setObject:@"Excel文档权限" forKey:@"Name"];

    NSMutableArray *excelRightsMtbArr = [NSMutableArray array];
    [excelRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以发送邮件" note:@"已废弃，使用“公共权限中的‘发送邮件’”代替" key:iAppOfficeRightsExcelIsSendMail value:@"0" available:NO]];
    [excelRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以分享" note:@"已废弃，使用“公共权限中的‘分享’”代替" key:iAppOfficeRightsExcelIsShare value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以导出为PDF" note:@"已废弃，使用“公共权限中的‘导出为PDF’”代替" key:iAppOfficeRightsExcelIsExportPDF value:@"0" available:NO]];
    [wordRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以打印" note:@"已废弃，使用“公共权限中的‘打印’”代替" key:iAppOfficeRightsExcelIsPrint value:@"0" available:NO]];
    [excelRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以本地保留" note:@"已废弃，使用“公共权限中的‘本地保留’" key:iAppOfficeRightsExcelIsLocalization value:@"0" available:NO]];
    [excelRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以另存" note:@"已废弃，使用“公共权限中的‘另存’”代替" key:iAppOfficeRightsExcelIsSaveAs value:@"0" available:NO]];
    [excelRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以编辑" note:@"已废弃，使用“公共权限中的‘编辑’”代替" key:iAppOfficeRightsExcelIsEditMode value:iAppOfficeRightsBoolValueNO available:NO]];
    [excelRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以复制" note:@"已废弃，使用“公共权限中的‘复制’”代替" key:iAppOfficeRightsExcelIsCopyEnable value:iAppOfficeRightsBoolValueNO available:NO]];

    [excelMtbDict setObject:excelRightsMtbArr forKey:@"Rights"];


    //PPT文档权限
    NSMutableDictionary *pptMtbDict = [NSMutableDictionary dictionary];
    [pptMtbDict setObject:@"PPT文档权限" forKey:@"Name"];

    NSMutableArray *pptRightsMtbArr = [NSMutableArray array];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以另存" note:@"已废弃，使用“公共权限中的‘另存’”代替" key:iAppOfficeRightsPPTIsSaveAs value:@"0" available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以本地保留" note:@"已废弃，使用“公共权限中的‘本地保留’代替" key:iAppOfficeRightsPPTIsLocalization value:@"0" available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以发送邮件" note:@"已废弃，使用“公共权限中的‘发送邮件’代替" key:iAppOfficeRightsPPTIsSendMail value:@"0" available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以共享播放" note:@"" key:iAppOfficeRightsPPTIsSharePlay value:@"0" available:YES]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以无线投影" note:@"已废弃，使用“公共权限中的‘无线投影’”代替" key:iAppOfficeRightsPPTIsWirelessProjection value:@"0" available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以打印" note:@"已废弃，使用“公共权限中的‘打印’”代替" key:iAppOfficeRightsPPTIsPrint value:@"0" available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以导出为PDF" note:@"已废弃，使用“公共权限中的‘导出为PDF’”代替" key:iAppOfficeRightsPPTIsExportPDF value:@"0" available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以分享" note:@"已废弃，使用“公共权限中的‘分享’”代替" key:iAppOfficeRightsPPTIsShare value:@"0" available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以编辑" note:@"已废弃，使用“公共权限中的‘编辑’”代替" key:iAppOfficeRightsPPTIsEditMode value:iAppOfficeRightsBoolValueNO available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否以编辑模式打开" note:@"已废弃，使用“公共权限中的‘以编辑模式打开’”代替" key:iAppOfficeRightsPPTIsOpenInEditMode value: iAppOfficeRightsBoolValueNO available:NO]];
    [pptRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以演讲实录" note:@"" key:iAppOfficeRightsPPTIsVoiceRecord value: iAppOfficeRightsBoolValueNO available:YES]];
    [pptMtbDict setObject:pptRightsMtbArr forKey:@"Rights"];

    //PDF文档权限
    NSMutableDictionary *pdfMtbDict = [NSMutableDictionary dictionary];
    [pdfMtbDict setObject:@"PDF文档权限" forKey:@"Name"];

    NSMutableArray *pdfRightsMtbArr = [NSMutableArray array];
    [pdfRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以发送邮件" note:@"已废弃，使用“公共权限中的‘发送邮件’代替" key:iAppOfficeRightsPDFIsShareAndSendMail value:iAppOfficeRightsBoolValueNO available:NO]];
    [pdfRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以另存" note:@"已废弃，使用“公共权限中的‘另存’”代替" key:iAppOfficeRightsPDFIsSaveIs value:iAppOfficeRightsBoolValueNO available:NO]];
    [pdfRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以打印" note:@"已废弃，使用“公共权限中的‘打印’”代替" key:iAppOfficeRightsPDFIsPrint value:iAppOfficeRightsBoolValueNO available:NO]];
    [pdfRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以编辑" note:@"已废弃，使用“公共权限中的‘编辑’”代替" key:iAppOfficeRightsPDFIsEidtEnable value:iAppOfficeRightsBoolValueNO available:NO]];
    [pdfRightsMtbArr addObject:[self rightsInfoWithName:@"是否可以复制" note:@"已废弃，使用“公共权限中的‘复制’”代替" key:iAppOfficeRightsPDFIsCopyEnable value:iAppOfficeRightsBoolValueNO available:NO]];
    [pdfRightsMtbArr addObject:[self rightsInfoWithName:@"是否本地保留" note:@"已废弃，使用“公共权限中的‘本地保留’代替" key:iAppOfficeRightsPDFIsLocalization value:iAppOfficeRightsBoolValueNO available:NO]];
    [pdfRightsMtbArr addObject:[self rightsInfoWithName:@"是否以编辑模式打开" note:@"已废弃，使用“公共权限中的‘以编辑模式打开’”代替" key:iAppOfficeRightsPDFIsOpenInEditMode value:iAppOfficeRightsBoolValueNO available:NO]];
    [pdfMtbDict setObject:pdfRightsMtbArr forKey:@"Rights"];

    [settingFileMtbDict setObject:publicMtbDict forKey:@"Public"];
    [settingFileMtbDict setObject:wordMtbDict forKey:@"Word"];
    [settingFileMtbDict setObject:excelMtbDict forKey:@"Excel"];
    [settingFileMtbDict setObject:pptMtbDict forKey:@"PPT"];
    [settingFileMtbDict setObject:pdfMtbDict forKey:@"PDF"];
    //    PLog(@"excel: %@", excelMtbDict);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *settingsPath = [path stringByAppendingPathComponent:@"Settings"];
    if ([[NSFileManager defaultManager] createDirectoryAtPath:settingsPath withIntermediateDirectories:YES attributes:nil error:nil]) {

        NSString *settingFilePath = [settingsPath stringByAppendingPathComponent:@"iAppOfficeRightsSetting.plist"];
        if ([[NSFileManager defaultManager] createFileAtPath:settingFilePath contents:nil attributes:nil]) {

            if ([settingFileMtbDict writeToFile:settingFilePath atomically:YES]) {

                return settingFilePath;
            }
            else {

                [[NSFileManager defaultManager] removeItemAtPath:settingFilePath error:nil];
            }
        }
    }
    return nil;
}

/*
 * 作者：段奕滨
 * 日期：2015-04-03 ~ 2016-12-19
 * 功能：设置权限字段
 * 参数：
 *     》name：名称
 *     》note：备注
 *     》key：键
 *     》value：值
 */
- (NSMutableDictionary *)rightsInfoWithName:(NSString *)name note:(NSString *)note key:(NSString *)key value:(NSString *)value available:(BOOL)available {

    NSMutableDictionary *rightsMtbDict = [NSMutableDictionary dictionary];
    [rightsMtbDict setObject:name forKey:@"Name"];
    [rightsMtbDict setObject:note forKey:@"Note"];
    [rightsMtbDict setObject:key forKey:@"Key"];
    [rightsMtbDict setObject:value forKey:@"Value"];
    [rightsMtbDict setObject:[NSNumber numberWithBool:available] forKey:@"Available"];

    return rightsMtbDict;
}

/*
 * 作者：段奕滨
 * 日期：2015-04-07
 * 功能：设置权限字段
 *     》key：字段键
 *     》value：字段值
 * 返回：保存是否成功
 */
- (BOOL)saveRightsToDocumentWithKey:(NSString *)key value:(NSString *)value {

    NSString *settingFilePath = [self rightsFileFromDocuments];
    NSMutableDictionary *settingFileMtbDict = [NSMutableDictionary dictionaryWithContentsOfFile:settingFilePath];
    for (int i = 0; i < settingFileMtbDict.count; i++) {

        NSString *typeStr = [[settingFileMtbDict allKeys] objectAtIndex:i];
        NSMutableDictionary *rightsMtbDict = [settingFileMtbDict objectForKey:typeStr];
        NSMutableArray *rightsMtbArr = [rightsMtbDict objectForKey:@"Rights"];
        for (int j = 0; j < rightsMtbArr.count; j++) {

            NSMutableDictionary *subRightsMtbDict = [rightsMtbArr objectAtIndex:j];
            NSString *rightsKey = [subRightsMtbDict objectForKey:@"Key"];
            if ([rightsKey isEqualToString:key]) {
                //                PLog(@"key: %@", key);
                [subRightsMtbDict setObject:value forKey:@"Value"];
                [rightsMtbArr replaceObjectAtIndex:j withObject:subRightsMtbDict];
                [rightsMtbDict setObject:rightsMtbArr forKey:@"Rights"];
                [settingFileMtbDict setObject:rightsMtbDict forKey:typeStr];

                return [settingFileMtbDict writeToFile:settingFilePath atomically:YES];
            }
        }
    }

    return NO;
}


@end
