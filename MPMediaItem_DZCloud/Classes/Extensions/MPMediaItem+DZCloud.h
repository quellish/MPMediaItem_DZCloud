//
//  MPMediaItem+DZCloud.h
//  MPMediaItem_DZCloud
//
//  Created by Dan Zinngrabe on 1/27/12.
//  Copyright (c) 2012 quellish.org . All rights reserved.
//

#ifndef __MPMEDIAITEM_DZCLOUD_H__
#define __MPMEDIAITEM_DZCLOUD_H__

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#if PRAGMA_ONCE
#pragma once
#endif

/*!
 Provides a simple method to tell if a given media item is in the local iPod library or if it is remote, such as 
 when it exists on iCloud/iTunes Match but not on the device. The MPMediaItem will still show up in media pickers or
  scanning the user's library, even though the content is not local to the device. This category provides a simple interface to tell wether the media item is on the device or not.
 
 */

@interface MPMediaItem ( DZCloud )

/*!
 
 discussion MPMediaItems have associated asset urls, accessed by the property MPMediaItemPropertyAssetURL. 
 On the local device, this will follow the format:
 ipod-library://item/item.m4a?id=MPMediaItemPropertyPersistentID
 Where MPMediaItemPropertyPersistentID is the persistent ID for the item. Other URLs can be present, but if the URL is nil, that should mean that the item exists on iCloud/iTunes Match rather than the local device.
 Starting playback of a remote item will download it in the background, but the user may have that functionality disabled - in which case playback just fails.
 
 @return NSURL asset URL for this media item.
 */

- (NSURL *) assetURL;

/*!
 
 discussion Boolean method that returns NO if the item is local in the user's iPod library, YES if it is not. Note that for non-music items, this could return YES for items that are present on the device but not in the iPod library (i.e. shared files, etc.)
 
 @return BOOL YES if the item's MPMediaItemPropertyAssetURL does not point to the local iPod library
 */

- (BOOL) isRemote;

@end
#endif
