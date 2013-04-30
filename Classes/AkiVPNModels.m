//
//  AkiVPNModels.m
//  AkiVPN
//
//  Created by luo  on 12-2-1.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "AkiVPNModels.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "OpenUDID.h"

#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation AkiGWFInfo

@synthesize currentBaseURL;
@synthesize currentIndex;
@synthesize iTry;
@synthesize strIndexEncodedAndEMed;

- (AkiGWFInfo *)init
{
	self = [super init];
	if (self)
	{
		currentBaseURL = [[NSMutableString alloc] initWithString:@""];
		strIndexEncodedAndEMed = [[NSMutableString alloc] initWithString:@""];
	}
	return self;
}

- (NSString *)getBaseURLWebService
{
	//NSString *strBaseURL = [NSString stringWithFormat:@"https://www.vfastvpn.com/iosclient/akivpn/"];
	//NSString *strBaseURL = [NSString stringWithFormat:@"http://192.168.1.12/iosclient/akivpn/"];
	//NSString *strBaseURL = [NSString stringWithFormat:@"%@%@", @"https://", currentURL];
	//return strBaseURL;
	NSString *strBaseURLWebService = [NSString stringWithFormat:@"https://%@/iosclient/akivpn/", currentBaseURL];
	return strBaseURLWebService;
}

- (void)initBaseURL
{
	NSString *strOriginIndex = [NSString stringWithFormat:@"11"];//@"10"];
	NSString *strOriginBaseURL = [NSString stringWithFormat:@"www.vfastvpn.com"];//@"www.vfvpn.com"];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults objectIsForcedForKey:@"index"] == NO)
	{
		[userDefaults setObject:strOriginIndex forKey:@"index"];
		[userDefaults setObject:strOriginBaseURL forKey:@"url"];
	}
	
	NSString *strIndex = [userDefaults objectForKey:@"index"];
	currentIndex = [strIndex intValue];
	NSString *strBaseURL = [userDefaults objectForKey:@"url"];
	[currentBaseURL release];
	currentBaseURL = [[NSMutableString alloc] initWithString:strBaseURL];
}

- (void)handleTimer:(NSTimer *)timer
{
	[self updateBaseURL];
}

- (void)updateBaseURL
{
	currentIndex += 4;
	iTry = 3;
	[self startRequest];
}

- (void)startRequest
{
	currentIndex --;
	iTry --;
	if (iTry == -1)
		return;
	
	NSString *strIndex = [NSString stringWithFormat:@"%d", currentIndex];
	NSString *strIndexEncoded = [Aki3DESUtils TripleDES:strIndex encryptOrDecrypt:1];
	NSString *strIndexEMed = [NSString stringWithFormat:@"<em>%@</em>,", strIndexEncoded];
	strIndexEncodedAndEMed = [[NSMutableString alloc] initWithFormat:@"%@", strIndexEMed];
	
	NSString *strIndexSubstituted = [strIndexEncoded stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	strIndexSubstituted = [strIndexSubstituted stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	strIndexSubstituted = [strIndexSubstituted stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
	NSString *strSearchIndex = [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@", strIndexSubstituted];
	
	NSURL *url = [NSURL URLWithString:strSearchIndex];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:5];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	NSString *responseString = [request responseString];
	// 当以二进制形式读取返回内容时用这个方法
	//NSData *responseData = [request responseData];
	
	if (responseString == nil)
	{
		[self startRequest];
		return;
	}
	NSRange range = [responseString rangeOfString:strIndexEncodedAndEMed];
	if (range.location == NSNotFound)
	{
		[self startRequest];
	}
	else
	{
		int iStart = range.location + range.length;
		int iEnd = iStart;
		while ([responseString characterAtIndex:iEnd] != '.')
			iEnd ++;
		
		NSString *strBaseURLEncoded = [responseString substringWithRange:NSMakeRange(iStart, iEnd - iStart)];
		NSString *strBaseURL = [Aki3DESUtils TripleDES2:strBaseURLEncoded encryptOrDecrypt:0];
		[currentBaseURL release];
		currentBaseURL = [[NSMutableString alloc] initWithString:strBaseURL];
		NSString *strIndex = [NSString stringWithFormat:@"%d", currentIndex];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:strIndex forKey:@"index"];
		[userDefaults setObject:strBaseURL forKey:@"url"];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Sorry, some error occurred.."
												   message:@"Can't connect to VPNHelper server."
												  delegate:self
										 cancelButtonTitle:@"ok"
										 otherButtonTitles:@"cancel", @"Ignore", nil];
	[alert show];
	[alert release];
	
	[self startRequest];
}

/*
- (NSString *)dnsLookup:(NSString *)strIP
{
	Boolean result;
	CFHostRef hostRef;
	NSArray *addresses;
	NSString *hostname = @"www.vfastvpn.com";
	hostRef = CFHostCreateWithName(kCFAllocatorDefault, (CFStringRef)hostname);
	if (hostRef)
	{
		result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
		// pass an error instead of NULL here to find out why it failed
		if (result == TRUE)
		{
			addresses = (NSArray*)CFHostGetAddressing(hostRef, &result);
		}
	}
	
	if (result == TRUE)
	{
		//[addresses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
		//{
		//	NSString *strDNS = [NSString stringWithUTF8String:inet_ntoa(*((struct in_addr *)obj))];
		//	NSLog(@"Resolved %d->%@", idx, strDNS);
		//	return strDNS;
		//}];
	}
	else
	{
		NSString *strDNS = [NSString stringWithFormat:@""];
		NSLog(@"Not resolved");
		return strDNS;
	}
}

- (void)pingDomainName
{
	NSString *strOriginIndex = [NSString stringWithFormat:@"0"];
	NSString *strOriginURL = [NSString stringWithFormat:@"https://www.vfastvpn.com/iosclient/akivpn/"];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults objectIsForcedForKey:@"index"] == NO)
	{
		[userDefaults setObject:strOriginIndex forKey:@"index"];
		[userDefaults setObject:strOriginURL forKey:@"url"];
	}
	
	NSString *strIndex = [userDefaults objectForKey:@"index"];
	NSString *strURL = [userDefaults objectForKey:@"url"];
	
}
*/

- (void)dealloc 
{
	[currentBaseURL release];
	[strIndexEncodedAndEMed release];
    [super dealloc];
}

@end

@implementation AkiUserInfo

@synthesize uDID;
@synthesize userID;
@synthesize fakeUserID;
@synthesize version;

- (AkiUserInfo *)init
{
	self = [super init];
	if (self)
	{
		uDID = [[NSMutableString alloc] initWithString:@""];
		userID = [[NSMutableString alloc] initWithString:@""];
		fakeUserID = [[NSMutableString alloc] initWithString:@"3"];
		version = [[NSMutableString alloc] initWithString:@"1.0"];
	}
	return self;
}

- (NSString *)getUserID
{
	//return fakeUserID;
	NSString *strUserID = [NSString stringWithFormat:@"%@", userID];
	return strUserID;
}

- (NSString *)getVersion
{
	NSString *strVersion = [NSString stringWithFormat:@"%@", version];
	return strVersion;
}

- (void)initUserID
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults objectIsForcedForKey:@"userid"] == NO)
	{
		[self startRequest];
	}
	else
	{
		NSString *strUDID = [userDefaults objectForKey:@"udid"];
		[uDID release];
		uDID = [[NSMutableString alloc] initWithString:strUDID];
		
		NSString *strUserID = [userDefaults objectForKey:@"userid"];
		[userID release];
		userID = [[NSMutableString alloc] initWithString:strUserID];
	}
}

- (void)startRequest
{

	NSString *strUDID = [OpenUDID value];
	NSString *strDeviceName = [[UIDevice currentDevice] name];
	NSString *strSystemName = [[UIDevice currentDevice] systemName];
	NSString *strSystemVersion = [[UIDevice currentDevice] systemVersion];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&udid=%@&devicename=%@&systemname=%@&systemversion=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"USER_LOGIN", strUDID, strDeviceName, strSystemName, strSystemVersion]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:5];
	[request startSynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictUserInfo = [parser objectWithString:strJSon error:nil];
	
	NSString *strUserID = [dictUserInfo objectForKey:@"UserID"];
	[userID release];
	userID = [[NSMutableString alloc] initWithString:strUserID];
	
	NSString *strUDID = [OpenUDID value];
	[uDID release];
	uDID = [[NSMutableString alloc] initWithString:strUDID];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:strUDID forKey:@"udid"];
	[userDefaults setObject:strUserID forKey:@"userid"];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Sorry, some error occurred.."
										message:@"Can't connect to VPNHelper server."
										delegate:self
										cancelButtonTitle:@"ok"
										otherButtonTitles:@"cancel", @"Ignore", nil];
	[alert show];
	[alert release];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"%@", alertView.title);
}

- (void)dealloc 
{
	[uDID release];
	[userID release];
	[fakeUserID release];
    [super dealloc];
}

@end

@implementation AkiServerInfo

@synthesize hasBeenLoaded;
@synthesize arrServerEntries;
@synthesize pingHelper;
@synthesize delegate;
@synthesize delegate3;

- (AkiServerInfo *)init
{
	self = [super init];
	if (self)
	{
		arrServerEntries = [[NSMutableArray alloc] init];
		pingHelper = [[PingHelper alloc] initWithId:self itemSel:@selector(pingResult:) allSel:@selector(pingFinished)];
		hasBeenLoaded = 0;
	}
	return self;
}

- (void)newPingHelper
{
	[pingHelper release];
	pingHelper = [[PingHelper alloc] initWithId:self itemSel:@selector(pingResult:) allSel:@selector(pingFinished)];
	
	for (int i = 0; i < [arrServerEntries count]; i ++)
	{
		AkiServerEntry *serverEntry = [arrServerEntries objectAtIndex:i];
		[pingHelper addPingTask:serverEntry.address atIndex:i];
	}
}

- (void)downloadVPNConfig:(NSString *)strServerID
{
	NSString *strURL = [NSString stringWithFormat:@"%@%@?serverid=%@&userid=%@",
						[g_akiGWFInfo getBaseURLWebService], @"ws_download.php", strServerID, [g_akiUserInfo getUserID]];
	NSURL *url = [NSURL URLWithString:strURL];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)downloadInformation
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_SERVER_LIST", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request startAsynchronous];
}

- (void)downloadInformationWithoutPing
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_SERVER_LIST", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinishedWithoutPing:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictServerEntries = [parser objectWithString:strJSon error:nil];
	
	[arrServerEntries removeAllObjects];
	[self newPingHelper];
	NSInteger i = 0;
	for (NSDictionary *dictServerEntry in dictServerEntries)
	{
		NSString *_id = [dictServerEntry objectForKey:@"ID"];
		NSString *code = [dictServerEntry objectForKey:@"Code"];
		NSString *countryCode = [dictServerEntry objectForKey:@"CountryCode"];
		NSString *desc = [dictServerEntry objectForKey:@"Desc"];
		NSString *address = [dictServerEntry objectForKey:@"Address"];
		NSString *free = [dictServerEntry objectForKey:@"Free"];
		NSString *status = [dictServerEntry objectForKey:@"Status"];
		NSString *load = [dictServerEntry objectForKey:@"Load"];
		AkiServerEntry *serverEntry = [[AkiServerEntry alloc] init];
		[serverEntry set_id:[_id intValue]];
		[serverEntry setCode:code];
		[serverEntry setCountryCode:countryCode];
		[serverEntry setDesc:desc];
		[serverEntry setAddress:address];
		[serverEntry setFree:[free intValue]];
		[serverEntry setStatus:status];
		[serverEntry setLoad:[load intValue]];
		[serverEntry setPing:0];
		[serverEntry setSelected:0];
		[serverEntry setIndex:i];
		[arrServerEntries addObject:serverEntry];
		[serverEntry release];
		
		//[pingHelper addPingTask:address atIndex:i];
		i ++;
	}
	[self.delegate finishDownloading];
	hasBeenLoaded = 1;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.delegate finishDownloading];
}

- (void)requestFinishedWithoutPing:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictServerEntries = [parser objectWithString:strJSon error:nil];
	
	[arrServerEntries removeAllObjects];
	[self newPingHelper];
	NSInteger i = 0;
	for (NSDictionary *dictServerEntry in dictServerEntries)
	{
		NSString *_id = [dictServerEntry objectForKey:@"ID"];
		NSString *code = [dictServerEntry objectForKey:@"Code"];
		NSString *countryCode = [dictServerEntry objectForKey:@"CountryCode"];
		NSString *desc = [dictServerEntry objectForKey:@"Desc"];
		NSString *address = [dictServerEntry objectForKey:@"Address"];
		NSString *free = [dictServerEntry objectForKey:@"Free"];
		NSString *status = [dictServerEntry objectForKey:@"Status"];
		NSString *load = [dictServerEntry objectForKey:@"Load"];
		AkiServerEntry *serverEntry = [[AkiServerEntry alloc] init];
		[serverEntry set_id:[_id intValue]];
		[serverEntry setCode:code];
		[serverEntry setCountryCode:countryCode];
		[serverEntry setDesc:desc];
		[serverEntry setAddress:address];
		[serverEntry setFree:[free intValue]];
		[serverEntry setStatus:status];
		[serverEntry setLoad:[load intValue]];
		[serverEntry setPing:0];
		[serverEntry setSelected:0];
		[serverEntry setIndex:i];
		[arrServerEntries addObject:serverEntry];
		[serverEntry release];
		
		//[pingHelper addPingTask:address atIndex:i];
		i ++;
	}
	//[self.delegate finishDownloading];
	hasBeenLoaded = 1;
}

- (void)pingResult:(PingTask*)pingTask
{
	AkiServerEntry *serverEntry = [arrServerEntries objectAtIndex:pingTask.index];
	if (pingTask.success)
		[serverEntry setPing:[pingTask delay]];
	else
		[serverEntry setPing:10000];
	[self.delegate3 finishOnePingAtIndex:pingTask.index];
}

- (void)pingFinished
{
	[self.delegate3 finishAllPings];
}

- (void)handleTimer:(NSTimer *)timer
{
	[self.delegate handleTimer:timer];
}

- (void)restoreIndices
{
	for (int i = 0; i < [arrServerEntries count]; i ++)
	{
		AkiServerEntry *serverEntry = [arrServerEntries objectAtIndex:i];
		[serverEntry setIndex:i];
	}
}

- (void)restorePings
{
	for (int i = 0; i < [arrServerEntries count]; i ++)
	{
		AkiServerEntry *serverEntry = [arrServerEntries objectAtIndex:i];
		[serverEntry setPing:0];
	}
}

- (void)dealloc 
{
	[arrServerEntries release];
	[pingHelper release];
    [super dealloc];
}

@end

@implementation AkiServerEntry

@synthesize _id;
@synthesize code;
@synthesize countryCode;
@synthesize desc;
@synthesize address;
@synthesize free;
@synthesize status;
@synthesize load;
@synthesize ping;
@synthesize selected;
@synthesize index;

- (void)dealloc 
{
	[code release];
	[desc release];
	[address release];
    [super dealloc];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AkiDataInfo

@synthesize hasBeenLoaded;
@synthesize primaryPlan;
@synthesize minorPlan;
@synthesize trafficUsed;
@synthesize trafficTotal;
@synthesize validDateStart;
@synthesize validDateEnd;
@synthesize restriction;
@synthesize delegate;

- (AkiDataInfo *)init
{
	self = [super init];
	if (self)
	{
		hasBeenLoaded = 0;
	}
	return self;
}

- (void)downloadInformation
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_DATA_PLAN", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictDataInfo = [parser objectWithString:strJSon error:nil];
	
	NSString *tmpPrimaryPlan = [dictDataInfo objectForKey:@"PrimaryPlan"];
	NSString *tmpMinorPlan = [dictDataInfo objectForKey:@"MinorPlan"];
	NSString *tmpTrafficUsed = [dictDataInfo objectForKey:@"TrafficUsed"];
	NSString *tmpTrafficTotal = [dictDataInfo objectForKey:@"TrafficTotal"];
	NSString *tmpValidDateStart = [dictDataInfo objectForKey:@"ValidDateStart"];
	NSString *tmpValidDateEnd = [dictDataInfo objectForKey:@"ValidDateEnd"];
	NSString *tmpRestriction = [dictDataInfo objectForKey:@"Restriction"];
	[self setPrimaryPlan:tmpPrimaryPlan];
	[self setMinorPlan:tmpMinorPlan];
	[self setTrafficUsed:[tmpTrafficUsed intValue]];
	[self setTrafficTotal:[tmpTrafficTotal intValue]];
	[self setValidDateStart:tmpValidDateStart];
	[self setValidDateEnd:tmpValidDateEnd];
	[self setRestriction:tmpRestriction];
	
	[self.delegate finishDownloading];
	hasBeenLoaded = 1;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.delegate finishDownloading];
}

- (void)handleTimer:(NSTimer *)timer
{
	[self.delegate handleTimer:timer];
}

- (void)dealloc 
{
	[primaryPlan release];
	[minorPlan release];
	[validDateStart release];
	[validDateEnd release];
	[restriction release];
    [super dealloc];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AkiPurchaseInfo

@synthesize hasBeenLoaded;
@synthesize arrPurchaseEntriesTraffic;
@synthesize arrPurchaseEntriesSubscription;
@synthesize arrHistoryEntries;
@synthesize formatter;
@synthesize delegate;

- (AkiPurchaseInfo *)init
{
	self = [super init];
	if (self)
	{
		arrPurchaseEntriesTraffic = [[NSMutableArray alloc] init];
		arrPurchaseEntriesSubscription = [[NSMutableArray alloc] init];
		arrHistoryEntries = [[NSMutableArray alloc] init];
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy/MM/dd"];
		hasBeenLoaded = 0;
		hasDownloadHowMany = 0;
	}
	return self;
}

- (void)downloadInformation
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_CARD_SCHEMES", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request startAsynchronous];
	
	NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_CARDS", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request2 = [ASIHTTPRequest requestWithURL:url2];
	[request2 setDelegate:self];
	[request2 setDidFinishSelector:@selector(requestFinished2:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request2 startAsynchronous];
	
	hasDownloadHowMany = 0;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictPurchaseEntries = [parser objectWithString:strJSon error:nil];
	
	[arrPurchaseEntriesTraffic removeAllObjects];
	[arrPurchaseEntriesSubscription removeAllObjects];
	for (NSDictionary *dictPurchaseEntry in dictPurchaseEntries)
	{
		NSString *serial = [dictPurchaseEntry objectForKey:@"Serial"];
		NSString *type = [dictPurchaseEntry objectForKey:@"Type"];
		NSString *intro = [dictPurchaseEntry objectForKey:@"Intro"];
		NSString *desc = [dictPurchaseEntry objectForKey:@"Desc"];
		NSString *price = [dictPurchaseEntry objectForKey:@"Price"];
		AkiPurchaseEntry *purchaseEntry = [[AkiPurchaseEntry alloc] init];
		[purchaseEntry setSerial:serial];
		[purchaseEntry setType:type];
		[purchaseEntry setIntro:intro];
		[purchaseEntry setDesc:desc];
		[purchaseEntry setPrice:[price intValue]];
		[purchaseEntry setSelected:0];
		if ([type isEqualToString:@"traffic"])
			[arrPurchaseEntriesTraffic addObject:purchaseEntry];
		else if ([type isEqualToString:@"subscription"])
			[arrPurchaseEntriesSubscription addObject:purchaseEntry];
		[purchaseEntry release];
	}
	
	hasDownloadHowMany ++;
	if (hasDownloadHowMany == 2)
	{
		hasDownloadHowMany = 0;
		[self.delegate finishDownloading];
		hasBeenLoaded = 1;
	}
}

- (void)requestFinished2:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictHistoryEntries = [parser objectWithString:strJSon error:nil];
	
	[arrHistoryEntries removeAllObjects];
	for (NSDictionary *dictHistoryEntry in dictHistoryEntries)
	{
		NSString *date = [dictHistoryEntry objectForKey:@"Date"];
		NSString *intro = [dictHistoryEntry objectForKey:@"Intro"];
		NSString *price = [dictHistoryEntry objectForKey:@"Price"];
		AkiHistoryEntry *historyEntry = [[AkiHistoryEntry alloc] init];
		NSTimeInterval dateInterval = [date intValue];
		[historyEntry setDate:[NSDate dateWithTimeIntervalSince1970:dateInterval]];
		[historyEntry setIntro:intro];
		[historyEntry setPrice:[price intValue]];
		[arrHistoryEntries addObject:historyEntry];
		[historyEntry release];
	}
	
	hasDownloadHowMany ++;
	if (hasDownloadHowMany == 2)
	{
		hasDownloadHowMany = 0;
		[self.delegate finishDownloading];
		hasBeenLoaded = 1;
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	hasDownloadHowMany ++;
	if (hasDownloadHowMany == 2)
	{
		hasDownloadHowMany = 0;
		[self.delegate finishDownloading];
	}
}

- (void)handleTimer:(NSTimer *)timer
{
	[self.delegate handleTimer:timer];
}

- (void)dealloc
{
	[arrPurchaseEntriesTraffic release];
	[arrPurchaseEntriesSubscription release];
	[arrHistoryEntries release];
	[formatter release];
	[super dealloc];
}

@end

@implementation AkiPurchaseEntry

@synthesize serial;
@synthesize type;
@synthesize intro;
@synthesize desc;
@synthesize price;
@synthesize selected;

- (void)dealloc 
{
	[serial release];
	[type release];
	[intro release];
	[desc release];
    [super dealloc];
}

@end

@implementation AkiHistoryEntry

@synthesize date;
@synthesize intro;
@synthesize price;

- (void)dealloc 
{
	[intro release];
    [super dealloc];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AkiUsageInfo

@synthesize hasBeenLoaded;
@synthesize arrUsageEntries;
@synthesize formatter;
@synthesize arrTrafficByDay;
@synthesize delegate;

- (AkiUsageInfo *)init
{
	self = [super init];
	if (self)
	{
		arrUsageEntries = [[NSMutableArray alloc] init];
		hasBeenLoaded = 0;
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
		arrTrafficByDay = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)downloadInformation
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_USAGE_LOG", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictUsageEntries = [parser objectWithString:strJSon error:nil];
	
	[arrUsageEntries removeAllObjects];
	for (NSDictionary *dictUsageEntry in dictUsageEntries)
	{	
		NSString *start = [dictUsageEntry objectForKey:@"Start"];
		NSString *duration = [dictUsageEntry objectForKey:@"Duration"];
		NSString *traffic = [dictUsageEntry objectForKey:	@"Traffic"];
		AkiUsageEntry *usageEntry = [[AkiUsageEntry alloc] init];
		[usageEntry setStart:[start intValue]];
		[usageEntry setDuration:[duration intValue]];
		NSTimeInterval startTimeInterval = [start intValue];
		NSTimeInterval endTimeInterval = [start intValue] + [duration intValue];
		[usageEntry setDateStart:[NSDate dateWithTimeIntervalSince1970:startTimeInterval]];
		[usageEntry setDateEnd:[NSDate dateWithTimeIntervalSince1970:endTimeInterval]];
		[usageEntry setTraffic:[traffic intValue]];
		[arrUsageEntries addObject:usageEntry];
		[usageEntry release];
	}
	[self calculateTrafficByDay];
	
	[self.delegate finishDownloading];
	hasBeenLoaded = 1;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.delegate finishDownloading];
}

- (void)calculateTrafficByDay
{
	NSInteger iNow = [[NSDate date] timeIntervalSince1970];
	NSInteger iNowByDay = iNow - iNow / 86400;
	
	int niTimeByDay[15];
	for (int i = 0; i < 15; i ++)
	{
		niTimeByDay[i] = iNowByDay - (13 - i) * 86400;
	}
	
	int niTrafficByDay[14];
	for (int i = 0; i < 14; i ++)
	{
		niTrafficByDay[i] = 0;
	}
	
	int iStart, iEnd;
	for (int i = 0; i < [arrUsageEntries count]; i ++)
	{
		AkiUsageEntry *usageEntry = [arrUsageEntries objectAtIndex:i];
		
		for (iStart = 1; iStart < 15; iStart ++)
		{
			if (usageEntry.start <= niTimeByDay[iStart])
				break;
		}
		
		for (iEnd = 1; iEnd < 15; iEnd ++)
		{
			if ((usageEntry.start + usageEntry.duration) <= niTimeByDay[iEnd])
				break;
		}
		
		if (iStart == iEnd)
		{
			niTrafficByDay[iStart - 1] += usageEntry.traffic;
		}
		else if (iStart + 1 == iEnd)
		{
			niTrafficByDay[iStart - 1] += (usageEntry.traffic * (niTimeByDay[iStart] - usageEntry.start) / usageEntry.duration);
			niTrafficByDay[iEnd - 1] += (usageEntry.traffic * (usageEntry.duration - niTimeByDay[iStart] + usageEntry.start) / usageEntry.duration);
		}
		else
		{
			
		}
	}
	
	[arrTrafficByDay removeAllObjects];
	for (int i = 0; i < 14; i ++)
	{
		[arrTrafficByDay addObject:[NSNumber numberWithInt:niTrafficByDay[i]]];
	}
}

- (void)handleTimer:(NSTimer *)timer
{
	[self.delegate handleTimer:timer];
}

- (void)dealloc
{
	[arrUsageEntries release];
	[formatter release];
	[arrTrafficByDay release];
	[super dealloc];
}

@end

@implementation AkiUsageEntry

@synthesize start;
@synthesize duration;
@synthesize dateStart;
@synthesize dateEnd;
@synthesize traffic;

- (void)dealloc 
{
    [super dealloc];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AkiHelpInfo

@synthesize hasBeenLoaded;
@synthesize arrHelpEntries;
@synthesize strHelp;
@synthesize delegate;

- (AkiHelpInfo *)init
{
	self = [super init];
	if (self)
	{
		arrHelpEntries = [[NSMutableArray alloc] init];
		strHelp = [[NSMutableString alloc] init];
		hasBeenLoaded = 0;
	}
	return self;
}

- (void)downloadInformation
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_FAQ", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictHelpEntries = [parser objectWithString:strJSon error:nil];
	
	[arrHelpEntries removeAllObjects];
	for (NSDictionary *dictHelpEntry in dictHelpEntries)
	{
		NSString *_id = [dictHelpEntry objectForKey:@"ID"];
		NSString *question = [dictHelpEntry objectForKey:@"Question"];
		NSString *answer = [dictHelpEntry objectForKey:@"Answer"];
		AkiHelpEntry *helpEntry = [[AkiHelpEntry alloc] init];
		[helpEntry set_id:[_id intValue]];
		[helpEntry setQuestion:question];
		[helpEntry setAnswer:answer];
		[arrHelpEntries addObject:helpEntry];
		[helpEntry release];
	}
	
	[self.delegate finishDownloading];
	hasBeenLoaded = 1;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.delegate finishDownloading];
}

- (void)handleTimer:(NSTimer *)timer
{
	[self.delegate handleTimer:timer];
}

- (void)dealloc
{
	[arrHelpEntries release];
	[strHelp release];
	[super dealloc];
}

@end

@implementation AkiHelpEntry

@synthesize _id;
@synthesize question;
@synthesize answer;

- (void)dealloc 
{
	[question release];
	[answer release];
    [super dealloc];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AkiChatInfo

@synthesize hasBeenLoaded;
@synthesize formatter;
@synthesize arrChatEntries;
@synthesize delegate;

- (AkiChatInfo *)init
{
	self = [super init];
	if (self)
	{
		arrChatEntries = [[NSMutableArray alloc] init];
		hasBeenLoaded = 0;
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:SS"];
	}
	return self;
}

- (void)downloadInformation
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_LIVE_CHAT_MESSAGES", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictChatEntries = [parser objectWithString:strJSon error:nil];
	
	[arrChatEntries removeAllObjects];
	for (NSDictionary *dictChatEntry in dictChatEntries)
	{
		NSString *_id = [dictChatEntry objectForKey:@"Udid"];
		NSString *date = [dictChatEntry objectForKey:@"Date"];
		NSTimeInterval dateInterval = [date intValue];
		NSString *direction = [dictChatEntry objectForKey:@"Direction"];
		NSString *nickname;
		if (direction == @"support")
			nickname = @"support";
		else
			nickname = @"me";
		NSString *content = [dictChatEntry objectForKey:@"Content"];
		AkiChatEntry *chatEntry = [[AkiChatEntry alloc] init];
		[chatEntry set_id:[_id intValue]];
		[chatEntry setDate:[NSDate dateWithTimeIntervalSince1970:dateInterval]];
		[chatEntry setDirection:direction];
		[chatEntry setNickname:nickname];
		[chatEntry setContent:content];
		[arrChatEntries addObject:chatEntry];
		[chatEntry release];
	}
	
	[self.delegate finishDownloading2];
	hasBeenLoaded = 1;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.delegate finishDownloading2];
}

- (void)handleTimer:(NSTimer *)timer
{
	[self.delegate handleTimer2:timer];
}

- (void)dealloc
{
	[formatter release];
	[arrChatEntries release];
	[super dealloc];
}

@end

@implementation AkiChatEntry

@synthesize _id;
@synthesize date;
@synthesize direction;
@synthesize nickname;
@synthesize content;

- (void)dealloc 
{
	[date release];
	[direction release];
	[nickname release];
	[content release];
    [super dealloc];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AkiMessageInfo

@synthesize hasBeenLoaded;
@synthesize arrMessageEntries;
@synthesize delegate;

- (AkiMessageInfo *)init
{
	self = [super init];
	if (self)
	{
		arrMessageEntries = [[NSMutableArray alloc] init];
		hasBeenLoaded = 0;
	}
	return self;
}

- (void)downloadInformation
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?op=%@&userid=%@", [g_akiGWFInfo getBaseURLWebService], @"ws.php", @"GET_MESSAGES", [g_akiUserInfo getUserID]]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	[request setTimeOutSeconds:3];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// 当以文本形式读取返回内容时用这个方法
	//NSString *responseString = [request responseString];
	//[textPassword setText:responseString];
	// 当以二进制形式读取返回内容时用这个方法
	NSData *responseData = [request responseData];
	
	NSString *strJSon = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[strJSon autorelease];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	[parser autorelease];
	NSDictionary *dictMessageEntries = [parser objectWithString:strJSon error:nil];
	
	[arrMessageEntries removeAllObjects];
	for (NSDictionary *dictMessageEntry in dictMessageEntries)
	{
		NSString *_id = [dictMessageEntry objectForKey:@"ID"];
		NSString *title = [dictMessageEntry objectForKey:@"Title"];
		NSString *content = [dictMessageEntry objectForKey:@"Content"];
		NSString *createdTime = [dictMessageEntry objectForKey:@"CreatedTime"];
		NSString *read = [dictMessageEntry objectForKey:@"Read"];
		AkiMessageEntry *messageEntry = [[AkiMessageEntry alloc] init];
		[messageEntry set_id:[_id intValue]];
		[messageEntry setTitle:title];
		[messageEntry setContent:content];
		[messageEntry setCreatedTime:createdTime];
		[messageEntry setRead:[read intValue]];
		[arrMessageEntries addObject:messageEntry];
		[messageEntry release];
	}
	
	[self.delegate finishDownloading];
	hasBeenLoaded = 1;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.delegate finishDownloading];
}

- (void)handleTimer:(NSTimer *)timer
{
	[self.delegate handleTimer:timer];
}

- (void)dealloc
{
	[arrMessageEntries release];
	[super dealloc];
}

@end

@implementation AkiMessageEntry

@synthesize _id;
@synthesize title;
@synthesize content;
@synthesize createdTime;
@synthesize read;

- (void)dealloc 
{
	[title release];
	[content release];
	[createdTime release];
    [super dealloc];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////
@implementation Aki3DESUtils


#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"       // Open source，base64处理，就两个文件，自己从网上下载下吧

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(NSInteger)encryptOrDecrypt
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == 0)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
	NSString *strKey = @"jamLALb3ovViKjJ/pfEhpfS/1YVYaItf";
	//NSData *dataKey = [strKey dataUsingEncoding:NSUTF8StringEncoding];
	NSData *dataKeyBase64 = [GTMBase64 decodeString:strKey];
	const void *vkey = [dataKeyBase64 bytes];
	
    NSString *strInitVec = @"Z4cSxdKg3ls=";
	//NSData *dataInitVec = [strInitVec dataUsingEncoding:NSUTF8StringEncoding];
	NSData *dataInitVecBase64 = [GTMBase64 decodeString:strInitVec];
	const void *vinitVec = [dataInitVecBase64 bytes];
	
    //const void *vkey = (const void *) [key UTF8String];
    //const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt((encryptOrDecrypt == 1)? kCCEncrypt : kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
	 else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
	 else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
	 else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
	 else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
	 else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == 0)
    {
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding]
                  autorelease];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

+ (NSString*)TripleDES2:(NSString*)plainText encryptOrDecrypt:(NSInteger)encryptOrDecrypt
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == 0)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
	NSString *strKey = @"mdN1EA2wny8J8MyzjPaaecgJIW3U6GhQ";
	//NSData *dataKey = [strKey dataUsingEncoding:NSUTF8StringEncoding];
	NSData *dataKeyBase64 = [GTMBase64 decodeString:strKey];
	const void *vkey = [dataKeyBase64 bytes];
	
    NSString *strInitVec = @"zghR/YHrlDE=";
	//NSData *dataInitVec = [strInitVec dataUsingEncoding:NSUTF8StringEncoding];
	NSData *dataInitVecBase64 = [GTMBase64 decodeString:strInitVec];
	const void *vinitVec = [dataInitVecBase64 bytes];
	
    //const void *vkey = (const void *) [key UTF8String];
    //const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt((encryptOrDecrypt == 1)? kCCEncrypt : kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
	 else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
	 else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
	 else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
	 else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
	 else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == 0)
    {
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding]
                  autorelease];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

@end