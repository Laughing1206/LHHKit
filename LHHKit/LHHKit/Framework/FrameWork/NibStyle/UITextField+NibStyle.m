//
//   ___           ___        ___      ___        ___
//  /\  \         /\  \      /\  \    /\  \      /\  \
//  \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//   \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//    \ \  \______  \ \  \     \ \  \   \ \  \     \ \  \
//     \ \________\  \ \__\     \ \__\   \ \__\     \ \__\
//      \/________/   \/__/      \/__/    \/__/      \/__/
//
//  欢欢为人民服务
//  有问题请联系我，http://www.jianshu.com/u/3c6ff28fdc63
//
// -----------------------------------------------------------------------------



#import "UITextField+NibStyle.h"
#import <objc/runtime.h>
static const char kUITextFieldNibMaxLegnthKey;
static const char kUITextFieldNibMustBeNumbericKey;

@implementation UITextField (NibStyle)

@dynamic nibMaxLength;
@dynamic nibMustBeNumberic;

- (void)setNibMaxLength:(NSInteger)nibMaxLength
{
	objc_setAssociatedObject(self, &kUITextFieldNibMaxLegnthKey, @(nibMaxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	self.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^(UITextField * textField, NSRange range, NSString * string)
	{
		NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];

		if ( [string isEqualToString:@""] )
		{
			return YES;
		}

		if ( nibMaxLength > 0 && text.length > nibMaxLength )
		{
			return NO;
		}

		return YES;
	};
}

- (BOOL)nibMustBeNumberic
{
	return [objc_getAssociatedObject(self, &kUITextFieldNibMaxLegnthKey) integerValue];
}

- (void)setNibMustBeNumberic:(BOOL)nibMustBeNumberic
{
    objc_setAssociatedObject(self, &kUITextFieldNibMustBeNumbericKey, @(nibMustBeNumberic), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^(UITextField * textField, NSRange range, NSString * string)
    {
        NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ( nibMustBeNumberic && text.length && ![text isNumber] )
        {
            return NO;
        }
        
        return YES;
    };
}

- (NSInteger)nibMaxLength
{
    return [objc_getAssociatedObject(self, &kUITextFieldNibMustBeNumbericKey) boolValue];
}

@end
