//
//  UIButton+AddIndexPath.m
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "UIButton+AddIndexPath.h"
#include <objc/runtime.h>

@implementation UIButton (AddIndexPath)

- (void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
    objc_setAssociatedObject(self, "cellIndexPath", cellIndexPath, OBJC_ASSOCIATION_COPY);
}

- (NSIndexPath *)cellIndexPath {
    return objc_getAssociatedObject(self, "cellIndexPath");
}
@end
