//
//  AkiVPNModels.h
//  AkiVPN
//
//  Created by luo  on 12-2-1.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PingHelper.h"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define BLUE RGB(68, 125, 225)
#define GREEN RGB(42, 153, 56)
#define YELLOW RGB(220, 154, 0)
#define RED RGB(225, 16, 24)
#define GRAY RGB(128, 128, 128)
#define WHITE RGB(255, 255, 255)
#define BLACK RGB(0, 0, 0)
#define CLEAR [UIColor clearColor]

#define LIGHT_GREEN RGB(3, 101, 100)
#define LIGHT_BROWN RGB(232, 221, 203)
#define DARK_GREEN RGB(3, 54, 73)
#define DARK_BROWN RGB(205, 179, 128)
#define LIGHT_GRAY RGB(242, 242, 242)

#define CPT(r, g, b) [CPTColor colorWithComponentRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define CPT_LIGHT_GREEN CPT(3, 101, 100)
#define CPT_DARK_GREEN CPT(3, 54, 73)
#define CPT_DARK_BROWN CPT(205, 179, 128)

@protocol AkiVPNModelsDelegate

- (void)finishDownloading;
- (void)handleTimer:(NSTimer *)timer;

@end

@protocol AkiVPNModelsDelegate2

- (void)finishDownloading2;
- (void)handleTimer2:(NSTimer *)timer;

@end

@protocol AkiVPNModelsDelegate3

- (void)finishOnePingAtIndex:(NSInteger)iIndex;
- (void)finishAllPings;

@end

@interface AkiGWFInfo : NSObject {
	NSMutableString *currentBaseURL;
	NSInteger currentIndex;
	NSInteger iTry;
	NSMutableString *strIndexEncodedAndEMed;
}

@property (nonatomic, retain) NSMutableString *currentBaseURL;
@property NSInteger currentIndex;
@property NSInteger iTry;
@property (nonatomic, retain) NSMutableString *strIndexEncodedAndEMed;

- (NSString *)getBaseURLWebService;
- (void)initBaseURL;
- (void)updateBaseURL;
- (void)startRequest;

@end

AkiGWFInfo *g_akiGWFInfo;


@interface AkiUserInfo : NSObject {
	NSMutableString *uDID;
	NSMutableString *userID;
	NSMutableString *fakeUserID;
	NSMutableString *version;
}

@property (nonatomic, retain) NSMutableString *uDID;
@property (nonatomic, retain) NSMutableString *userID;
@property (nonatomic, retain) NSMutableString *fakeUserID;
@property (nonatomic, retain) NSMutableString *version;

- (NSString *)getUserID;
- (void)initUserID;
- (void)startRequest;
- (NSString *)getVersion;

@end

AkiUserInfo *g_akiUserInfo;

@interface AkiServerInfo : NSObject {
	NSInteger hasBeenLoaded;
	NSMutableArray *arrServerEntries;
	PingHelper *pingHelper;
	NSObject<AkiVPNModelsDelegate> *delegate;
	NSObject<AkiVPNModelsDelegate3> *delegate3;
}

@property NSInteger hasBeenLoaded;
@property (nonatomic, retain) NSMutableArray *arrServerEntries;
@property (nonatomic, retain) PingHelper *pingHelper;
@property (nonatomic, retain) NSObject<AkiVPNModelsDelegate> *delegate;
@property (nonatomic, retain) NSObject<AkiVPNModelsDelegate3> *delegate3;

- (void)newPingHelper;
- (void)downloadVPNConfig:(NSString *)strServerID;
- (void)downloadInformation;
- (void)downloadInformationWithoutPing;
- (void)restoreIndices;
- (void)restorePings;

@end

@interface AkiServerEntry : NSObject {
	NSInteger _id;
	NSString *code;
	NSString *countryCode;
	NSString *desc;
	NSString *address;
	NSInteger free;
	NSString *status;
	NSInteger load;
	NSInteger ping;
	NSInteger selected;
	
	NSInteger index;
}

@property NSInteger _id;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *address;
@property NSInteger free;
@property (nonatomic, retain) NSString *status;
@property NSInteger load;
@property NSInteger ping;
@property NSInteger selected;
@property NSInteger index;

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@interface AkiDataInfo : NSObject {
	NSInteger hasBeenLoaded;
	NSString *primaryPlan;
	NSString *minorPlan;
	NSInteger trafficUsed;
	NSInteger trafficTotal;
	NSString *validDateStart;
	NSString *validDateEnd;
	NSString *restriction;
	NSObject<AkiVPNModelsDelegate> *delegate;
}
@property NSInteger hasBeenLoaded;
@property (nonatomic, retain) NSString *primaryPlan;
@property (nonatomic, retain) NSString *minorPlan;
@property NSInteger trafficUsed;
@property NSInteger trafficTotal;
@property (nonatomic, retain) NSString *validDateStart;
@property (nonatomic, retain) NSString *validDateEnd;
@property (nonatomic, retain) NSString *restriction;
@property (nonatomic, retain) NSObject<AkiVPNModelsDelegate> *delegate;

- (void)downloadInformation;

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@interface AkiPurchaseInfo : NSObject {
	NSInteger hasBeenLoaded;
	NSMutableArray *arrPurchaseEntriesTraffic;
	NSMutableArray *arrPurchaseEntriesSubscription;
	NSMutableArray *arrHistoryEntries;
	NSDateFormatter* formatter;
	NSObject<AkiVPNModelsDelegate> *delegate;
	
	NSInteger hasDownloadHowMany;
}

@property NSInteger hasBeenLoaded;
@property (nonatomic, retain) NSMutableArray *arrPurchaseEntriesTraffic;
@property (nonatomic, retain) NSMutableArray *arrPurchaseEntriesSubscription;
@property (nonatomic, retain) NSMutableArray *arrHistoryEntries;
@property (nonatomic, retain) NSDateFormatter* formatter;
@property (nonatomic, retain) NSObject<AkiVPNModelsDelegate> *delegate;

- (void)downloadInformation;

@end

@interface AkiPurchaseEntry : NSObject {
	NSString *serial;
	NSString *type;
	NSString *intro;
	NSString *desc;
	NSInteger price;
	NSInteger selected;
}

@property (nonatomic, retain) NSString *serial;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *intro;
@property (nonatomic, retain) NSString *desc;
@property NSInteger price;
@property NSInteger selected;

@end

@interface AkiHistoryEntry : NSObject {
	NSDate *date;
	NSString *intro;
	NSInteger price;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *intro;
@property NSInteger price;

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@interface AkiUsageInfo : NSObject {
	NSInteger hasBeenLoaded;
	NSMutableArray *arrUsageEntries;
	NSDateFormatter* formatter;
	NSMutableArray *arrTrafficByDay;
	NSObject<AkiVPNModelsDelegate> *delegate;
}

@property NSInteger hasBeenLoaded;
@property (nonatomic, retain) NSMutableArray *arrUsageEntries;
@property (nonatomic, retain) NSDateFormatter* formatter;
@property (nonatomic, retain) NSMutableArray *arrTrafficByDay;
@property (nonatomic, retain) NSObject<AkiVPNModelsDelegate> *delegate;

- (void)downloadInformation;
- (void)calculateTrafficByDay;

@end

@interface AkiUsageEntry : NSObject {
	NSInteger start;
	NSInteger duration;
	NSDate *dateStart;
	NSDate *dateEnd;
	NSInteger traffic;
}

@property NSInteger start;
@property NSInteger duration;
@property (nonatomic, retain) NSDate *dateStart;
@property (nonatomic, retain) NSDate *dateEnd;
@property NSInteger traffic;

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@interface AkiHelpInfo : NSObject {
	NSInteger hasBeenLoaded;
	NSMutableArray *arrHelpEntries;
	NSMutableString *strHelp;
	NSObject<AkiVPNModelsDelegate> *delegate;
}

@property NSInteger hasBeenLoaded;
@property (nonatomic, retain) NSMutableArray *arrHelpEntries;
@property (nonatomic, retain) NSMutableString *strHelp;
@property (nonatomic, retain) NSObject<AkiVPNModelsDelegate> *delegate;

- (void)downloadInformation;

@end

@interface AkiHelpEntry : NSObject {
	NSInteger _id;
	NSString *question;
	NSString *answer;
}

@property NSInteger _id;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@interface AkiChatInfo : NSObject {
	NSInteger hasBeenLoaded;
	NSDateFormatter* formatter;
	NSMutableArray *arrChatEntries;
	NSObject<AkiVPNModelsDelegate2> *delegate;
}

@property NSInteger hasBeenLoaded;
@property (nonatomic, retain) NSDateFormatter* formatter;
@property (nonatomic, retain) NSMutableArray *arrChatEntries;
@property (nonatomic, retain) NSObject<AkiVPNModelsDelegate2> *delegate;

- (void)downloadInformation;

@end

@interface AkiChatEntry : NSObject {
	NSInteger _id;
	NSDate *date;
	NSString *direction;
	NSString *nickname;
	NSString *content;
}

@property NSInteger _id;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *direction;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *content;

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@interface AkiMessageInfo : NSObject {
	NSInteger hasBeenLoaded;
	NSMutableArray *arrMessageEntries;
	NSObject<AkiVPNModelsDelegate> *delegate;
}

@property NSInteger hasBeenLoaded;
@property (nonatomic, retain) NSMutableArray *arrMessageEntries;
@property (nonatomic, retain) NSObject<AkiVPNModelsDelegate> *delegate;

- (void)downloadInformation;

@end

@interface AkiMessageEntry : NSObject {
	NSInteger _id;
	NSString *title;
	NSString *content;
	NSString *createdTime;
	NSInteger read;
}

@property NSInteger _id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *createdTime;
@property NSInteger read;

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@interface Aki3DESUtils : NSObject
{

}

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(NSInteger)encryptOrDecrypt;
+ (NSString*)TripleDES2:(NSString*)plainText encryptOrDecrypt:(NSInteger)encryptOrDecrypt;

@end