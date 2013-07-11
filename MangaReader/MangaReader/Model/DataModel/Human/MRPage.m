#import "MRPage.h"
#import "MRHTTPClient.h"
#import <AFNetworking/AFImageRequestOperation.h>


@interface MRPage ()

// Private interface goes here.

@end


@implementation MRPage

+ (void)downloadImageForPage:(MRPage *)page completion:(void (^)(UIImage *image))completion
{
    if (page.image != nil) {
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:page.url]];
    request.HTTPMethod = @"GET";
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        page.image = UIImageJPEGRepresentation(image, 1);
        if (completion) {
            completion(image);
        }
        
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        TFLog(error.description);
    }];
    
    [operation start];
}

@end
