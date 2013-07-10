//
//  MRHTTPClient.m
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-09.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRHTTPClient.h"

static NSString *baseURL = @"http://dcwither-mangareader-api.appspot.com";
static MRHTTPClient *sharedClient;

@implementation MRHTTPClient

+ (MRHTTPClient *)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [MRHTTPClient new];
        
    });
    
    return sharedClient;
}

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:baseURL]];
    if (self) {
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    
    return self;
}

@end
