//
//  ActivationCodeTextField.h
//
//  Created by Sandeep Aggarwal on 16/03/17.
//  Copyright © 2017 Sandeep Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivationCodeTextField : UITextField

@property (nonatomic, assign) NSInteger maxCodeLength;
@property (nonatomic, strong) NSString* customPlaceholder;

- (CGFloat) minWidthTextField;

@end
