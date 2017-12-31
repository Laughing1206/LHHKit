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

#import "PinView.h"
// Calculate the final position
static inline CGPoint CalculateFinalPosition(CGRect bounds, CGRect current, CGFloat padding, CGFloat verticalBounds);

// Make the pin visible while under your finger
static inline CGPoint AdjustedPosition(UIView * view);

#pragma mark -

@interface PinView()
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) UILongPressGestureRecognizer * gesture;
@end

@implementation PinView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _padding = 8;
    _verticalBounds = 80;
    
    [self loadLayout];
    
    self.gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    self.gesture.minimumPressDuration = 0.3;
    [self addGestureRecognizer:self.gesture];
    [self performSelector:@selector(fadeOut) withObject:nil afterDelay:5];
}

#pragma mark -

- (void)loadLayout
{
//    NSString * value = [[NSUserDefaults standardUserDefaults] objectForKey:@"stipinview.frame"];
//
//    if ( value )
//    {
//        self.frame = CGRectFromString(value);
//    }
}

- (void)saveLayout
{
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromCGRect(self.frame) forKey:@"stipinview.frame"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma amrk -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [self pointInside:point withEvent:event];
    
    if ( inside )
    {
        [self fadeIn];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        [self performSelector:@selector(fadeOut) withObject:nil afterDelay:5];
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(CGPoint)point
{
    self.lastPoint = point;
    self.center = AdjustedPosition(self);
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                     }
                     completion:nil];
}

- (void)touchesMoved:(CGPoint)point
{
    float offsetX = point.x - self.lastPoint.x;
    float offsetY = point.y - self.lastPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

- (void)touchesEnded:(CGPoint)point
{
    if (self.superview )
    {
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             CGRect frame = self.frame;
                             frame.origin = CalculateFinalPosition(self.superview.frame,
                                                                   self.frame,
                                                                   self.padding,
                                                                   self.verticalBounds);
                             [UIView animateWithDuration:0.12
                                              animations:^{
                                                  self.frame = frame;
                                                  [self saveLayout];
                                              }];
                         }];
    }
}

- (void)fadeIn
{
    //    [UIView animateWithDuration:0.3 animations:^{
    self.alpha = 1;
    //    }];
}

- (void)fadeOut
{
    if ( self.notChangeAlpha )
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
}

#pragma mark -

- (void)longPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch ( gestureRecognizer.state ) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan: {
            [self touchesBegan:[gestureRecognizer locationInView:self]];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self touchesMoved:[gestureRecognizer locationInView:self]];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed: {
            [self touchesEnded:[gestureRecognizer locationInView:self]];
            break;
        }
    }
}

@end

static inline CGPoint AdjustedPosition(UIView * view)
{
    //    return view.center;
    CGRect frame = view.frame;
    CGFloat x = view.center.x;
    CGFloat y = view.center.y;
    CGFloat width = frame.size.width / 8;
    CGFloat height = frame.size.height / 8;
    
    // TODO: UIEdgeInsets
    return CGPointMake(x - width, y - height);
}

static inline CGPoint CalculateFinalPosition(CGRect bounds, CGRect current, CGFloat padding, CGFloat verticalBounds)
{
    CGFloat left   = CGRectGetMinX(current);
    CGFloat right  = bounds.size.width - CGRectGetMaxX(current);
    CGFloat top    = CGRectGetMinY(current);
    CGFloat bottom = bounds.size.height - CGRectGetMaxY(current);
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    BOOL isInMiddle = NO;
    
    if ( top < verticalBounds ) // top
    {
        y = padding;
    }
    else if ( bottom < verticalBounds ) // bottom
    {
        y = bounds.size.height - current.size.height - padding;
    }
    else // middle
    {
        isInMiddle = YES;
        y = current.origin.y;
    }
    
    if ( isInMiddle )
    {
        if ( left < right ) // left
        {
            x = padding;
        }
        else // right
        {
            x = bounds.size.width - current.size.width - padding;
        }
    }
    else
    {
        x = current.origin.x ;
        
        if ( left < 0 ) // left
        {
            x = padding;
        }
        else if ( right < 0 ) // right
        {
            x = bounds.size.width - current.size.width - padding;
        }
    }
    
    return CGPointMake(x, y);
}
