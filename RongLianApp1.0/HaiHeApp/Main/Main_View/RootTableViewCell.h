//
//  RootTableViewCell.h
//  HaiHeApp
//
//  Created by 马广召 on 16/3/3.
//  Copyright © 2016年 马广召. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketButton.h"
#import "BackMoneyObj.h"
@interface RootTableViewCell : UITableViewCell
@property (nonatomic, retain)RedPacketButton * button;
@property (nonatomic, retain)BackMoneyObj * listObj;
@end
