#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GoogleApiAvailabilityPlugin.h"

FOUNDATION_EXPORT double google_api_availabilityVersionNumber;
FOUNDATION_EXPORT const unsigned char google_api_availabilityVersionString[];

