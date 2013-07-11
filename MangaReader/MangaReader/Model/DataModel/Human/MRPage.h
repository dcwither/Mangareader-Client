#import "_MRPage.h"

@interface MRPage : _MRPage {}

+ (void)downloadImageForPage:(MRPage *)page completion:(void (^)(UIImage *image))completion;

@end
