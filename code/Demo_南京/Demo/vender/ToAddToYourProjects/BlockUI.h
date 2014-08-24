//
//  BlockUI.h
//
//  Created by Gustavo Ambrozio on 14/2/12.
//

#ifndef BlockUI_h
#define BlockUI_h
// Action Sheet constants

#define kActionSheetBounce         10
#define kActionSheetBorder         10
#define kActionSheetButtonHeight   45
#define kActionSheetTopMargin      15

#define kActionSheetTitleFont           [UIFont systemFontOfSize:18]
#define kActionSheetTitleTextColor      [UIColor whiteColor]
#define kActionSheetTitleShadowColor    [UIColor blackColor]
#define kActionSheetTitleShadowOffset   CGSizeMake(0, -1)

#define kActionSheetButtonFont          [UIFont boldSystemFontOfSize:20]
#define kActionSheetButtonTextColor     [UIColor whiteColor]
#define kActionSheetButtonShadowColor   [UIColor blackColor]
#define kActionSheetButtonShadowOffset  CGSizeMake(0, -1)

#define kActionSheetBackground              @"action-sheet-panel.png"
#define kActionSheetBackgroundCapHeight     30


// Alert View constants

#define kAlertViewBounce         20
#define kAlertViewBorder         10
#define kAlertButtonHeight       40

#define kAlertViewTitleFont             [UIFont boldSystemFontOfSize:19]
#define kAlertViewTitleTextColor        kAlertViewMessageTextColor
#define kAlertViewTitleShadowColor      [UIColor clearColor]
#define kAlertViewTitleShadowOffset     CGSizeMake(0, -1)

#define kAlertViewMessageFont           [UIFont systemFontOfSize:15]
#define kAlertViewMessageTextColor      [UIColor colorWithRed:(32 / 255.0) green:(32 / 255.0) blue:(32 / 255.0) alpha:1]
#define kAlertViewMessageShadowColor        [UIColor clearColor]

#define kAlertViewMessageShadowOffset   CGSizeMake(0, -1)

#define kAlertViewButtonFont            [UIFont boldSystemFontOfSize:18]
#define kAlertViewButtonTextColor       kAlertViewMessageTextColor
#define kAlertViewButtonShadowColor     [UIColor clearColor]
#define kAlertViewButtonShadowOffset    CGSizeMake(0, -1)

#define kAlertViewBackground            @"smallPopoverBG.png"
#define kAlertViewBackgroundCapHeight   38

#endif
