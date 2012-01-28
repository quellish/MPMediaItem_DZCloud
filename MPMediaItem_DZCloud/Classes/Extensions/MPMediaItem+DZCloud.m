//
//  MPMediaItem+DZCloud.m
//  MPMediaItem_DZCloud
//
//  Created by Dan Zinngrabe on 1/27/12.
//  Copyright (c) 2012 quellish.org . All rights reserved.
//

#import "MPMediaItem+DZCloud.h"

NSString * const kLibraryURLScheme         = @"ipod-library://";

@implementation MPMediaItem (DZCloud)

- (NSURL *) assetURL {
    NSURL    *result    = nil;
    
    // Note that if the item is remote and gets downloaded, this will still return the 
    // pre-download value because of the objc_setAssociatedObject caching. The valueForProperty
    // call can be terribly expensive, so using objc_setAssociatedObject to cache the result
    // can be a big win.
    // Also note that if the media item has an old version of FairPlay DRM, the MPMediaItemPropertyAssetURL will
    // return nil. At that point, there isn't much we can do, since detecting DRM entails creating an AVPlayerItem
    // from the MPMediaItem, and checking the hasProtectedContent property. We can only create the AVPlayerItem with
    // a non-nil MPMediaItemPropertyAssetURL, so.... yeah.
    // @see http://developer.apple.com/library/ios/#documentation/mediaplayer/reference/MPMediaItem_ClassReference/Reference/Reference.html%23//apple_ref/doc/c_ref/MPMediaItemPropertyAssetURL
    
    // TODO: Look at invalidating the associated object reference after X seconds using a dispatch timer.
    // An MPMediaLibraryDidChangeNotification can also invalidate this while your app is running
    result = objc_getAssociatedObject(self, MPMediaItemPropertyAssetURL);
    if (result == nil){
        result = [self valueForProperty:MPMediaItemPropertyAssetURL];
        objc_setAssociatedObject(self, MPMediaItemPropertyAssetURL, result, OBJC_ASSOCIATION_RETAIN);
    }
    return result;
}

- (BOOL) isRemote {
    BOOL        result      = YES;
    NSURL       *url        = nil;
    
    url = [self assetURL];
    if (url != nil){
        if ([[url scheme] isEqualToString:kLibraryURLScheme]){
            result = NO;
        }
    } else {
        
        // If the url was nil, we're assuming this means it's a remote item
        // there are conditions where this may not be true, like if the content is using older DRM
        // but there is no practical way to check that.
        // For example, if you got nil, you could construct a URL based on some assumptions, using the persistent ID...
        // [NSString stringWithFormat:@"ipod-library://item/item.m4p?id=%@", [self valueForProperty:MPMediaItemPropertyPersistentID] ];
        // And then pass that to an AVAsset as a url.
        // After a lot of testing, this does not look like it's useful or necessary - but leaving this
        // here commented out in case later testing proves otherwise. 
        
        /**
         NSString    *urlString  = nil;
         AVURLAsset  *avItem     = nil;
         
        urlString = [[NSString alloc] initWithFormat:@"%@item/item.m4p?id=%@", kLibraryURLScheme, [self valueForProperty:MPMediaItemPropertyPersistentID] ];
        url = [[NSURL alloc] initWithString:urlString];
        avItem = [[AVURLAsset alloc] initWithURL:url options:nil];
        if (avItem != nil && avItem.hasProtectedContent){
            result = NO;
        }
        [url release];
        [avItem release];
        [urlString release];
        url = nil;
        avItem = nil;
        urlString = nil;
        **/
    }

    return result;
}

@end
