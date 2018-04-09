//
//  JXWebViewController.h
//

#import "JXBaseViewController.h"

@interface JXWebViewController : JXBaseViewController

@property(nonatomic, copy) NSString* netString;

@property(nonatomic, assign) BOOL isModal;

@property(nonatomic, copy) voidBlock finished;

@end
