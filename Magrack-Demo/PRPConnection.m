/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PRPConnection.m
//  SimpleDownload
//
//  Created by Matt Drance on 3/1/10.
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import "PRPConnection.h"

@interface PRPConnection ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, copy)   NSURL *url;
@property (nonatomic, copy) NSURLRequest *urlRequest;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, assign) NSInteger contentLength;
@property (nonatomic, assign) float previousMilestone;

@property (nonatomic, copy) PRPConnectionProgressBlock progressBlock;
@property (nonatomic, copy) PRPConnectionCompletionBlock completionBlock;

@end


@implementation PRPConnection

@synthesize url;
@synthesize dosyaadi;
@synthesize urlRequest;
@synthesize connection;
@synthesize contentLength;
@synthesize downloadData;
@synthesize progressThreshold;
@synthesize previousMilestone;

@synthesize progressBlock;
@synthesize completionBlock;

- (void)dealloc {
 url = nil;
    urlRequest = nil;
   connection = nil;
 downloadData = nil;
     progressBlock = nil;
completionBlock = nil;
dosyaadi=nil;
    

}

+ (id)connectionWithRequest:(NSURLRequest *)request
              progressBlock:(PRPConnectionProgressBlock)progress
            completionBlock:(PRPConnectionCompletionBlock)completion {
    return [[self alloc] initWithRequest:request
                            progressBlock:progress
                          completionBlock:completion];
}

+ (id)connectionWithURL:(NSURL *)downloadURL
          progressBlock:(PRPConnectionProgressBlock)progress
        completionBlock:(PRPConnectionCompletionBlock)completion {
    return [[self alloc] initWithURL:downloadURL
                        progressBlock:progress
                     completionBlock:completion] ;

}

- (id)initWithURL:(NSURL *)requestURL
    progressBlock:(PRPConnectionProgressBlock)progress
  completionBlock:(PRPConnectionCompletionBlock)completion {
    return [self initWithRequest:[NSURLRequest requestWithURL:requestURL]
                   progressBlock:progress
                 completionBlock:completion];
}

- (id)initWithRequest:(NSURLRequest *)request
        progressBlock:(PRPConnectionProgressBlock)progress 
      completionBlock:(PRPConnectionCompletionBlock)completion {
    if ((self = [super init])) {
        urlRequest = [request copy];
        progressBlock = [progress copy];
        completionBlock = [completion copy];
        url = [[request URL] copy];
        progressThreshold = 1.0;
    }
    return self;
}

#pragma mark -
#pragma mark 

- (void)start {
    self.connection = [NSURLConnection connectionWithRequest:self.urlRequest delegate:self];
}

- (void)stop {
    [self.connection cancel];
    self.connection = nil;
    self.downloadData = nil;
    self.contentLength = 0;
    self.progressBlock = nil;
    self.completionBlock = nil;
    self.dosyaadi=nil;
}

- (float)percentComplete {
    if (self.contentLength <= 0) return 0;
    return (([self.downloadData length] * 1.0f) / self.contentLength) * 100;
}

#pragma mark 
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] == 200) {
            NSDictionary *header = [httpResponse allHeaderFields];
            NSString *contentLen = [header valueForKey:@"Content-Length"];
            NSInteger length = self.contentLength = [contentLen integerValue];
            self.downloadData = [NSMutableData dataWithCapacity:length];
        }
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];
    float pctComplete = floor([self percentComplete]);
    if ((pctComplete - self.previousMilestone) >= self.progressThreshold) {
        self.previousMilestone = pctComplete;
        if (self.progressBlock) self.progressBlock(self);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed");
    if (self.completionBlock) self.completionBlock(self, error);
    self.connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *resourceDocPath = [[NSString alloc] initWithString:[[[[NSBundle mainBundle]  resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Documents"]];
    
    NSString *filePath = [resourceDocPath stringByAppendingPathComponent:dosyaadi];
    
    [downloadData writeToFile:filePath atomically:YES];

    if (self.completionBlock) self.completionBlock(self, nil);
    self.connection = nil;
}

@end