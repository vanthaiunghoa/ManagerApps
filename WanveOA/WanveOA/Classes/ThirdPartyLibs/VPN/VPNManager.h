//
//  VPNManager.h
//  VPNManager
//

#import <Foundation/Foundation.h>

#define DISABLE_VPN_COMPAT_SOCKET_API
#import "arrayapi.h"
#import "vpn_error.h"

extern NSString * const kVPNMessageNotification;

typedef enum {
    FieldTypePasswordText,
    FieldTypeUsernameText,
    FieldTypeDeviceNameText
} InputFieldType;

/** AAAMethod.
 *
 * This class represents an authentication method sent by the AG server.
 * 
 * An AAAMethod object contains a list of InputField objects which provide the information
 * of the authentication servers and request the authentication information from the users.
 *
 */
@interface AAAMethod : NSObject

/// Method name.
@property (nonatomic, strong) NSString *name;

/// Method description.
@property (nonatomic, strong) NSString *methodDescription;

/// All input fields of this method.
@property (nonatomic, strong) NSMutableArray *inputFields;

@end

/*! InputField.
 *
 * This class tells developers what information the authentication server needs from users.
 *
 * 1. If the type is FieldTypeUsernameText, then a username is needed.
 *
 * 2. If the type is FieldTypeUsernameText, then a password is needed.
 *
 * 3. If the type is FieldTypeDeviceNameText, then a device name is needed.
 *
 */
@interface InputField : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fieldDescription;
@property (nonatomic) InputFieldType type;
@property (nonatomic, strong) NSString *inputString;
@end

#pragma mark - VPNAccount

/**
 * This class is used to hold the user credentials for login, such as the username, password, certificate path, etc.
 */
@interface VPNAccount :NSObject <NSCoding,NSCopying>

@property(nonatomic, strong) NSString *host;
@property(nonatomic, strong) NSString *port;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *passWord;
@property(nonatomic, strong) NSString *passWord2;
@property(nonatomic, strong) NSString *passWord3;
@property(nonatomic, strong) NSString *alias;
@property(nonatomic, strong) NSString *certificatePath;
@property(nonatomic, strong) NSString *certificatePassword;

@property(nonatomic, strong) NSString *methodName;
@property(nonatomic, strong) NSString *deviceName;

/// Init VPNAccount with host, username, and password
- (VPNAccount *)initWithHost:(NSString *)host userName:(NSString *)user passWord:(NSString *)passwd;

/// Init VPNAccount with host, port, username, and 3 passwords.
- (VPNAccount *)initWithHost:(NSString *)host
                        port:(NSString *)port
                    userName:(NSString *)user
                    passWord:(NSString *)passwd
                   passWord2:(NSString *)passwd2
                   passWord3:(NSString *)passwd3;

/// Init VPNAccount with host, port, username, 3 passwords, certificate file path and certificate password.
- (VPNAccount *)initWithHost:(NSString *)host
                        port:(NSString *)port
                    userName:(NSString *)user
                    passWord:(NSString *)passwd
                   passWord2:(NSString *)passwd2
                   passWord3:(NSString *)passwd3
             certificatePath:(NSString *)cert
         certificatePassword:(NSString *)certpass;

@end


#pragma mark - VPNMessage

/** VPNMessage
 *
 * These messages will send by VPNManager on main thread.
 *
 * To observe this message, you should add an observer to NSNotificationCenter with notification name kVPNMessageNotification.
 */
@interface VPNMessage :NSObject

/** VPN message code
 * @see arrayapi.h VPN_CB_XXX
 */
- (NSInteger)code;

/** Error code
 * @see vpn_error.h ERR_XXX
 */
- (NSInteger)error;

//not use
- (id)object;
@end


#pragma mark - VPNManager

/** VPNManager
 *
 * This class is responsible for VPN tunnel management such as starting/stopping VPN tunnel and sending VPN message. 
 
 * It is designed to be single-instance. Use "shareVPNManager" to get the shared instance.
 */
@interface VPNManager : NSObject

@property (nonatomic, strong, readonly) VPNAccount * account;

/// Device-independent identifier
@property (nonatomic, strong, readonly) NSString *deviceID;

/** Error code
 * @see vpn_error.h
 */
@property (nonatomic, readonly) NSInteger errorCode;

/** VPN status
 * @see arrayapi.h
 */
@property (nonatomic, readonly) NSInteger status;

/** 
 * Whether to enable HTTP proxy.
 *
 * This value should be setted before VPN connected.
 * 
 * Default value is YES.
 */
@property (nonatomic) BOOL httpProxyEnable;

/**
 *  Flag to start VPN.
 *  @note this falg should be setted before VPN starts
 *
 *  Default value is VPN_FLAG_SOCK_PROXY|VPN_FLAG_HTTP_PROXY|VPN_FLAG_PROXY_SCOPE_ALL|VPN_FLAG_LOGOUT_DEV_SESSION
 *
 *  @see arrayapi.h array_vpn_start falgs
 */
@property (nonatomic) NSUInteger startVPNFlag;

/// Get the shared VPNManager instance.
+ (VPNManager *)sharedVPNManager;

/// Get SDK version.
+ (NSString *)version;

/**
 * Start the VPN tunnel with the given account.
 * @param account infomations to start VPN, host, port, username and so on.
 * @return 0 if succeed, othervize > 0.
 */
- (int)startVPN:(VPNAccount *)account;

/// Stop the VPN tunnel.
- (void)stopVPN;

/**
 * Use this method to register the device, and the user input in this method will be authenticated by the AG server.
 * @note: this method must be invoked if the application received the message VPN_CB_LOGIN.
 * @param method the method the user choose to do device registration.
 */
- (void)loginWithMethod:(AAAMethod *)method;

/**
 *  Continue login with account.
 *
 *  @param account account informations to login, login method, username, passwords and so on.
 */
- (void)loginWithAccount:(VPNAccount *)account;

/**
 * Use this method to log in, and the user input in this method will be authenticated by the AG server.
 * @note this method must be invoked if the application received the message VPN_CB_DEVID_REG.
 * @param method the method the user choose to do authentication.
 */
- (void)registerWithMethod:(AAAMethod *)method;

- (void)registerWithAccount:(VPNAccount *)account;

/// Cancel the login during the connecting process.
- (void)cancelLogin;

/**
 * Set the SDK log level.
 * @param level the log level(LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR). Defaults to LOG_INFO.
 */
- (void)setLogLevel:(int)level;

/**
 * Generate a virtual host and a virtual port for the original host and port defined through constructor.
 * @return a reference to this object that contains the virtual ip and port.
 */
- (int)createTCPProxyEntry:(NSString *)host port:(int)port;

/**
 * Get the port of the HTTP proxy.
 * @return the port of the HTTP proxy.
 */
- (int)httpProxyPort;

/**
 * Get all AAA methods
 * @return a list of AAAMethod instances.
 */
- (NSArray *)allAAAMehtods;


@end


