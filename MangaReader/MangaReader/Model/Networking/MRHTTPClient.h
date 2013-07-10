//
//  MRHTTPClient.h
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-09.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "AFHTTPClient.h"

@interface MRHTTPClient : AFHTTPClient

+ (MRHTTPClient *)sharedClient;

@end
