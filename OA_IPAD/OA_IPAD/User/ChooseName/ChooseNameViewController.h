//
//  ChooseNameViewController.h
//  OA_IPAD
//
//  Created by cello on 2018/4/7.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ChooseNameMode) {
    ChooseNameModeSingle,
    ChooseNameModeMultiple,
};

@class ChooseNameViewController, Personel;
@protocol ChooseNameViewControllerDelegate<NSObject>

- (void)controller:(ChooseNameViewController *)controller
 didChoosePersonel:(Personel *)aGuy;

- (void)controller:(ChooseNameViewController *)controller didConfirmPensonel:(NSArray<Personel *> *)confirmGuys;

@end

@interface ChooseNameViewController : UIViewController

@property (nonatomic) ChooseNameMode mode;
@property (weak, nonatomic) id<ChooseNameViewControllerDelegate> delegate;
@property (weak, nonatomic) id referenceObject;

- (void)setSelectedPersonel:(NSArray<Personel *>*) selectedPersonelList;

@end
