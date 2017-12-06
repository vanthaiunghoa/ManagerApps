#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KGWPSDocumentsType) {
    KGWPSDocumentsTypeWord = 0,
    KGWPSDocumentsTypeExcel,
    KGWPSDocumentsTypePPT,
    KGWPSDocumentsTypePDF
};

@interface ReceiveDetailViewController : UIViewController

@property (assign, nonatomic) KGWPSDocumentsType documentsType;

@end
