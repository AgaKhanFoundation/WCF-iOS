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

#import "AZSAccessCondition.h"
#import "AZSAuthenticationHandler.h"
#import "AZSBlobContainerProperties.h"
#import "AZSBlobOutputStream.h"
#import "AZSBlobProperties.h"
#import "AZSBlobRequestFactory.h"
#import "AZSBlobRequestOptions.h"
#import "AZSBlobRequestXML.h"
#import "AZSBlobResponseParser.h"
#import "AZSBlobUploadHelper.h"
#import "AZSBlockListItem.h"
#import "AZSClient.h"
#import "AZSCloudAppendBlob.h"
#import "AZSCloudBlob.h"
#import "AZSCloudBlobClient.h"
#import "AZSCloudBlobContainer.h"
#import "AZSCloudBlobDirectory.h"
#import "AZSCloudBlockBlob.h"
#import "AZSCloudClient.h"
#import "AZSCloudPageBlob.h"
#import "AZSCloudStorageAccount.h"
#import "AZSConstants.h"
#import "AZSContinuationToken.h"
#import "AZSCopyState.h"
#import "AZSCorsRule.h"
#import "AZSEnums.h"
#import "AZSErrors.h"
#import "AZSExecutor.h"
#import "AZSIPRange.h"
#import "AZSLoggingProperties.h"
#import "AZSMacros.h"
#import "AZSMetricsProperties.h"
#import "AZSNavigationUtil.h"
#import "AZSNoOpAuthenticationHandler.h"
#import "AZSOperationContext.h"
#import "AZSRequestFactory.h"
#import "AZSRequestOptions.h"
#import "AZSRequestResult.h"
#import "AZSResponseParser.h"
#import "AZSResultSegment.h"
#import "AZSRetryContext.h"
#import "AZSRetryInfo.h"
#import "AZSRetryPolicy.h"
#import "AZSServiceProperties.h"
#import "AZSSharedAccessAccountParameters.h"
#import "AZSSharedAccessBlobParameters.h"
#import "AZSSharedAccessHeaders.h"
#import "AZSSharedAccessPolicy.h"
#import "AZSSharedAccessSignatureHelper.h"
#import "AZSSharedKeyBlobAuthenticationHandler.h"
#import "AZSStorageCommand.h"
#import "AZSStorageCredentials.h"
#import "AZSStorageUri.h"
#import "AZSULLRange.h"
#import "AZSUriQueryBuilder.h"
#import "AZSUtil.h"

FOUNDATION_EXPORT double AZSClientVersionNumber;
FOUNDATION_EXPORT const unsigned char AZSClientVersionString[];

