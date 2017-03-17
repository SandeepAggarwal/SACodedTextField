//
//  ActivationCodeTextField.h
//
//  Created by Sandeep Aggarwal on 16/03/17.
//  Copyright © 2017 Sandeep Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivationCodeTextField : UITextField

/**
 
 @abstract The code length. Defaults to 6.
 
 */
@property (nonatomic, assign) NSInteger maxCodeLength;

/**
 
 @abstract The placeholder visible until the text field is full. Defaults to '_'.
 
 */
@property (nonatomic, strong) NSString* customPlaceholder;

/**
 
 @returns minimum width required based upon 'maxCodeLength' and 'customPlaceholder'
 
 */
- (CGFloat) minWidthTextField;

@end
