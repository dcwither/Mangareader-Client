#import "_MRChapter.h"

@interface MRChapter : _MRChapter {}

+ (void)updatePagesForChapter:(MRChapter *)chapter WithJSON:(NSArray *)JSON completion:(void (^)( ))completion;

@end
