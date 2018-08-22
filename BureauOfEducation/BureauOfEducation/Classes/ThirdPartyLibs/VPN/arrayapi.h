/*
Array Networks SSL VPN API
Copyright (c) 2012 Array Networks, Inc. All rights reserved.
*/

#pragma once

#include <stddef.h>
#include <stdint.h>

#ifndef _WIN32
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <netdb.h>
#else
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#undef  FD_SETSIZE
#define FD_SETSIZE      1024
#include <winsock2.h>
typedef int socklen_t;

#endif

#ifdef _WINDLL
#define ARRAYAPI_DECL __declspec(dllexport)
#else
#define ARRAYAPI_DECL
#endif

#include "vpn_error.h"

/* level parameter of array_vpn_set_log_level */
#ifdef __ANDROID__
#include <android/log.h>
#define	LOG_ERROR     ANDROID_LOG_ERROR
#define	LOG_WARNING   ANDROID_LOG_WARN
#define	LOG_INFO      ANDROID_LOG_INFO
#define	LOG_DEBUG     ANDROID_LOG_DEBUG
#else
#define	LOG_ERROR     3
#define	LOG_WARNING   2
#define	LOG_INFO      1
#define	LOG_DEBUG     0
#endif

#define LOG_TO_STDOUT 0x0001
#define LOG_TO_FD     0x0002
#define LOG_WITH_TIME 0x0004
#define LOG_TO_DEBUG  0x0008
#define LOG_TO_SYSLOG 0x0010
#define LOG_TO_FILE   0x0020

/* audit log level */
#define AUDIT_EMERG   0   /* system is unusable */
#define AUDIT_ALERT   1   /* action must be taken immediately */
#define AUDIT_CRIT    2   /* critical conditions */
#define AUDIT_ERR     3   /* error conditions */
#define AUDIT_WARNING 4   /* warning conditions */
#define AUDIT_NOTICE  5   /* normal but significant condition */
#define AUDIT_INFO    6   /* informational */
#define AUDIT_DEBUG   7   /* debug-level messages */

/* vpn status */
#define VPN_IDLE			0
#define VPN_CONNECTING		1
#define VPN_CONNECTED		2
#define VPN_DISCONNECTING	3
#define VPN_RECONNECTING	4

/* VPN callback's 'cmd' */
#define VPN_CB_CONNECTING            1  /* connecting */
#define VPN_CB_CONN_FAILED           2  /* connect failed */
#define VPN_CB_CONNECTED             3  /* connected */
#define VPN_CB_DISCONNECTING         4  /* disconecting */
#define VPN_CB_DISCONNECTED          5  /* disconected */
#define VPN_CB_CONFIG_REQUEST        6  /* internal used */
#define VPN_CB_RECONNECTING          7  /* reconnecting */
#define VPN_CB_CHOOSE_CLIENT_CERT    8  /* choose certificate */
#define VPN_CB_INPUT_CERT_PASS		 9  /* input certificate password */
#define VPN_CB_SERVER_CERT           10 /* verify server certificate  */
#define VPN_CB_CHOOSE_SITE           11 /* choose site */
#define VPN_CB_CV_GLOBAL             12 /* prelogin CV rules  */
#define VPN_CB_LOGIN                 13 /* login */
#define VPN_CB_CHANGPASSWORD         14 /* localdb change password */
#define VPN_CB_CHALLENGE             15 /* radius challenge */
#define VPN_CB_VDI_AUTH              16 /* DD vdi auth */
#define VPN_CB_SMX                   17 /* SMX */
#define VPN_CB_SMX_CHANGEPASS        18 /* SMX change password */
#define VPN_CB_SMS                   19 /* SMS */
#define VPN_CB_CV_USER               20 /* CV postlogin rules */
#define VPN_CB_DEVID_REG			 21 /* device register */
#define VPN_CB_RESOURCES             22 /* resources */
#define VPN_CB_SSO                   23 /* SSO */
#define VPN_CB_PROTECT_SOCK	         24 /* protect socket */
#define VPN_CB_PROXY_AUTH	         25 /* outside proxy auth */
#define VPN_CB_HARDWARE_ID	         26 /* hardware id */
#define VPN_CB_CLIENT_SECURITY       27 /* client security */


/* default bind port of vpn http proxy */
#define VPN_HTTP_PROXY_DEFAULT_PORT  8080

/* array_vpn_start disp */
#define VPN_DISP_AlltoTCP	0
#define VPN_DISP_TCPtoTCP	1
#define VPN_DISP_TCPtoUDP	2
#define VPN_DISP_AlltoUDP	3

/* array_vpn_start falgs */
#define VPN_FLAG_HTTP_PROXY             0x00000001   /* enable http proxy */
#define VPN_FLAG_SOCK_PROXY             0x00000002   /* enable sock proxy */
#define VPN_FLAG_PROXY_SCOPE_PROCESS    0x00000004   /* allow clients from the same process*/
#define VPN_FLAG_PROXY_SCOPE_LOCALHOST  0x00000008   /* allow clients from the same localhost */
#define VPN_FLAG_PROXY_SCOPE_ALL        0x00000010   /* allow all clients */
#define VPN_FLAG_DEVID_LOGIN            0x00000020   /* use devid to login */
#define VPN_FLAG_MOTIONPRO_V2           0x00000040   /* api for motionpro 2.0 */
#define VPN_FLAG_LOGOUT_DEV_SESSION     0x00000080   /* logout device's all session before login */
#define VPN_FLAG_MOTIONPRO_V1           0x00000100   /* api for motionpro 1.0 */
#define VPN_FLAG_NATIVE_L3VPN           0x00000200   /* enable native l3vpn */
#define VPN_FLAG_DESKTOP_DIRECT         0x00000400   /* desktop direct */
#define VPN_FLAG_CHANGEPASS_ONLY        0x00000800   /* only do change password */
#define VPN_FLAG_LOGIN_ONLY             0x00001000   /* only do login and get resources */
#define VPN_FLAG_TUNEMU                 0x00002000   /* use tunemu api to handle tun, for max os x */
#define VPN_FLAG_SKIP_LOGOUT            0x00004000   /* do not logout session before vpn stop */
#define VPN_FLAG_L4VPN_TCP_PROXY        0x00008000   /* use l4vpn for tcp proxy */
#define VPN_FLAG_L4VPN_ONLY             0x00010000   /* use l4vpn only, disable l3vpn, only tcp proxy work */
#define VPN_FLAG_API_V2                 0x80000000   /* internal use */

#define ERR_MSG_MAX_LEN             256

/* copy from an_defines.h  */
#define METHOD_MAX					5
#define MULTI_NUM					2
#define USERNAME_LEN				64
#define PASSWORD_LEN				64
#define AAA_SEV_NAME_LEN			32
#define AAA_SEV_DISPLAY_LEN			127
#define VSITE_NAME_LEN				63
#define ROLE_NAME_LEN				63
#define CLIENTCERT_MAX_FIELDSLEN	256
#define DEVID_LEN					255
#define DEVNAME_LEN					512

typedef enum  {
    AUTH_LDAP			= 0,
    AUTH_LOCALDB		= 1,
    AUTH_RADIUS			= 2,
    AUTH_CERTIFICATE	= 3,
    AUTH_RADIUS_ACCOUNT	= 4,
    AUTH_KERVEROS		= 5,
    AUTH_EXTERNAL		= 6,
    AUTH_SMS            = 7,
    AUTH_DEVID          = 8,
    AUTH_SMX            = 9,
} auth_type_t;

typedef enum  {
    CERT_ANONYMOUS = 0,
    CERT_CHALLENGE = 1,
    DEVID_BINDUSER = 2,
} auth_action_t;

typedef enum {
    CERTID_NONE	= 0,
    CERTID_SHOW	= 1,
    CERTID_GET	= 2,
} auth_cert_id_type_t;

typedef enum {
    INVALID_DEVICE = 0,
    SPX_VPN_DEVICE = 1,
    AG_VPN_DEVICE  = 2,
    MN_DEVICE      = 3,
    DUMMY_DEVICE   = 4
} vpn_device_type_t;

#pragma pack(push, 1)
typedef struct {
    char server[AAA_SEV_NAME_LEN + 1];
    char desc[AAA_SEV_DISPLAY_LEN + 1];
    auth_type_t type;
    auth_action_t action;
} auth_multi_method_t;

typedef struct  {
    char name[AAA_SEV_NAME_LEN + 1];
    char desc[AAA_SEV_DISPLAY_LEN + 1];
    char server[AAA_SEV_NAME_LEN + 1];
    char server_desc[AAA_SEV_DISPLAY_LEN + 1];
    auth_type_t		    type;
    auth_action_t		action;
    auth_cert_id_type_t	cert_id_type;
    char				cert_id_value[CLIENTCERT_MAX_FIELDSLEN+1];
    unsigned int		multi_step_num;
    auth_multi_method_t	multi_steps[MULTI_NUM];
} auth_method_t;

typedef struct {
    vpn_device_type_t   dev_type;
    uint8_t				hwid_on;
    uint8_t				client_security_on;
    uint8_t				rank_on;
    int8_t  			rank_method_idx;
    int8_t				def_method_idx;
    uint8_t				method_num;
    int32_t             err_msd_id;
    auth_method_t		methods[METHOD_MAX];
    char                err_msg[ERR_MSG_MAX_LEN];
    char                vsite[VSITE_NAME_LEN+1];
} aaa_auth_info_t;

typedef struct {
    char method[AAA_SEV_NAME_LEN + 1];
    char user[USERNAME_LEN + 1];
    char pass[PASSWORD_LEN + 1];
    char pass2[PASSWORD_LEN + 1];
    char pass3[PASSWORD_LEN + 1];
    char devid[DEVID_LEN + 1];
    char devname[DEVNAME_LEN + 1];
} aaa_auth_input_t;

typedef enum {
    SMX_ACTION_UNKNOWN         = 0,
    SMX_ACTION_INPUT_PASS      = 1,
    SMX_ACTION_INPUT_OLD_PASS  = 2,
    SMX_ACTION_INPUT_NEW_PASS  = 3,
    SMX_ACTION_PASS_CONFIRM    = 4,
} vpn_smx_action_t;

typedef struct {
    vpn_smx_action_t    action;
    char                boxcount[8];
    char                charcheck[8];
    char                recpno[16];
    char                matrixres[32];
    char                pospass[128];
    char                title[64];
    char                errmsg[128];
} vpn_smx_info_t;

typedef struct {
    char                info[256];
    char                errmsg[256];
} vpn_challenge_info_t;

typedef struct {
    char *domain;
    char *cookie;
} cookie_entry_t;

typedef void* vpn_vsite_conn_t;

#define PROXY_AUTH_MAX_LEN    256

typedef enum  {
    PROXY_TYPE_NONE,
    PROXY_TYPE_MANUAL,
} proxy_type_t;

typedef enum  {
    PROXY_AUTH_INVALID,
    PROXY_AUTH_BASIC,
    PROXY_AUTH_NTLM,
} proxy_auth_t;

typedef struct {
    proxy_auth_t type;
    char         server[64];    
} proxy_auth_info_t;

typedef void* proxy_auth_ctx_t;

#define SMS_MAX_LEN     16

typedef struct {
    char                result[256];
    char                msg[256];
} vpn_sms_info_t;


typedef struct {
    char     *version;
    char     *settings;
} vpn_client_security_t;

typedef int(*array_vpn_callback) (int cmd, int error, const void *in, uint32_t in_len, void *out, uint32_t *out_len);

#define VPN_CONN_TIMEOUT_ARRAY_MAX_LEN   10
#define VPN_RECONN_CACHE_IP_ALWAYS       0x01
#define VPN_RECONN_CACHE_IP_AUTO_DETECT  0x02

typedef struct {
    uint8_t                  version;
    const char              *host;
    uint32_t                 ip;
    vpn_device_type_t        server_type;
    int                      port;
    const char              *alias;
    const char              *method;
    const char              *username;
    const char              *password;
    const char              *password2;
    const char              *password3;
    const char              *session;
    const char              *validcode;
    const char              *devid;
    const char              *devname;
    const char              *hardwareid;
    const char              *cert_path;
    const char              *cert_password;
    const char              *cert_data;
    uint32_t                 cert_data_len;
    uint8_t                  udp_enable;
    uint8_t                  udp_encrypt;
    uint8_t                  tunnel_dispatch;
    uint32_t                 reconn_max_count;
    uint32_t                 reconn_max_time;
    uint32_t                 reconn_interval;
    const char              *last_session_id;
    uint32_t                 flags;
    array_vpn_callback       callback;
    uint8_t                  conn_timeout[VPN_CONN_TIMEOUT_ARRAY_MAX_LEN];
    uint8_t                  reconn_cache_ip_flags;
    uint8_t                  reconn_cache_ip_timout;
    char			        *clientid;
    
} vpn_parameter_t;

#pragma pack(pop)

#define ARRAY_VPN_PROXY_FLAG_RESERVE_PORT       0x00000001
#define ARRAY_VPN_PROXY_FLAG_SET_HOST        0x00000002

#ifdef __cplusplus
extern "C" {
#endif
    
    ARRAYAPI_DECL int  array_vpn_start(const char *host,
        int         port,
        const char *alias,
        const char *aaa_method,
        const char *user,
        const char *pass,
        const char *pass2,
        const char *pass3,
        const char *sess,
        const char *validcode,
        const char *devid,
        const char *devname,
        const char *cert_path,
        const char *cert_pass,
        const char *cert_data,
        uint32_t    cert_data_len,
        int         udp_enable,
        int         udp_encrypt,
        int         tunnel_disp,
        int         reconn_count,
        int         reconn_max_time,
        uint32_t    flags,
        array_vpn_callback cb);

    ARRAYAPI_DECL int  array_vpn_start2(vpn_parameter_t p);

    ARRAYAPI_DECL int  array_vpn_stop();
    ARRAYAPI_DECL int  array_vpn_stop2(uint32_t flags);

    /* rport & vip & vport is in network byte order */
    ARRAYAPI_DECL int array_vpn_tcp_proxy_entry_create(const char *rhost, uint16_t rport, uint32_t *vip, uint16_t *vport);
    ARRAYAPI_DECL int array_vpn_tcp_proxy_entry_create2(const char *rhost, uint16_t rport, uint32_t *vip, uint16_t *vport, uint32_t flags);
    ARRAYAPI_DECL int array_vpn_udp_proxy_entry_create(const char *rhost, uint16_t rport, uint32_t *vip, uint16_t *vport);
    ARRAYAPI_DECL int array_vpn_tcp_proxy_entry_close(uint32_t vip, uint16_t vport);
    ARRAYAPI_DECL int array_vpn_udp_proxy_entry_close(uint32_t vip, uint16_t vport);

    ARRAYAPI_DECL void array_vpn_set_log_level(int level, unsigned char reserved);
    ARRAYAPI_DECL void array_vpn_set_log_opt(uint32_t flags, void *val);

    extern int  array_vpn_log_level_;
#define array_vpn_log(x, ...) if (x >= array_vpn_log_level_) { array_vpn_logprint(x, __VA_ARGS__); }
    ARRAYAPI_DECL void array_vpn_logprint(int level, const char *format, ...);
    
    typedef void(*array_vpn_log_callback) (int level, const char *msg);
    ARRAYAPI_DECL void array_vpn_set_log_callback(array_vpn_log_callback callback);
    
    ARRAYAPI_DECL int  array_vpn_get_status();

    ARRAYAPI_DECL int  array_vpn_get_stats(uint64_t *send_bytes,  uint64_t *recv_bytes);

    ARRAYAPI_DECL int  array_vpn_get_sockets_protect(int *tcpsock, int *udpsock);

    ARRAYAPI_DECL int  array_vpn_http_proxy_get_port(uint16_t *port);

    ARRAYAPI_DECL void array_vpn_enter_background();

    ARRAYAPI_DECL void array_vpn_enter_foreground();

    ARRAYAPI_DECL int  array_vpn_vsite_connect(vpn_vsite_conn_t *conn);
    ARRAYAPI_DECL int  array_vpn_vsite_request(vpn_vsite_conn_t conn, const char *header, char *resp, uint32_t *resp_len);
    ARRAYAPI_DECL int  array_vpn_vsite_http_get(vpn_vsite_conn_t conn, const char *url, const char *req_headers, const char *cookies, char **body, uint32_t *body_len, char **resp_headers);
    ARRAYAPI_DECL void array_vpn_vsite_http_free(void *ptr);
    ARRAYAPI_DECL int  array_vpn_vsite_post(vpn_vsite_conn_t conn, const char *header, char *post_data, uint32_t len, char *resp_buf, uint32_t *resp_buf_len);
    ARRAYAPI_DECL void array_vpn_vsite_close(vpn_vsite_conn_t conn);

    ARRAYAPI_DECL int  array_vpn_audit_log(int level, int id, char *log);

    ARRAYAPI_DECL int  array_vpn_tcs_connect(vpn_vsite_conn_t *conn);
    ARRAYAPI_DECL int  array_vpn_tcs_close(vpn_vsite_conn_t conn);
    ARRAYAPI_DECL int  array_vpn_get_sso_info(vpn_vsite_conn_t conn, char *user, uint32_t *user_len, char *pass, uint32_t *pass_len);
    ARRAYAPI_DECL int  array_vpn_resolve_host(vpn_vsite_conn_t conn, const char *host, uint32_t *ip);

    ARRAYAPI_DECL int  array_vpn_get_devid(char *devid, uint32_t len);
    ARRAYAPI_DECL int  array_vpn_get_cookies(char* buf, size_t len);
    ARRAYAPI_DECL int  array_vpn_get_clientid(char* buf, size_t len);
    ARRAYAPI_DECL int  array_vpn_get_sessionid(char* buf, size_t len);
    ARRAYAPI_DECL int  array_vpn_get_server_type(vpn_device_type_t *type);
    ARRAYAPI_DECL int  array_vpn_get_server_ip(uint32_t *ip);
    ARRAYAPI_DECL int  array_vpn_get_server_port(uint16_t *port);
    ARRAYAPI_DECL int  array_vpn_get_server_host(char *host, size_t len);
    ARRAYAPI_DECL int  array_vpn_get_virtual_ip(uint32_t *ip);

    ARRAYAPI_DECL int  array_vpn_change_password(auth_type_t type, const char *server);
    ARRAYAPI_DECL int  array_vpn_dynamic_acl_get_status(int *status);
    ARRAYAPI_DECL int  array_vpn_dynamic_acl_send(const unsigned char *rules, uint32_t rules_len, unsigned short timeout, unsigned char *resp, uint32_t *resp_len);

    ARRAYAPI_DECL int  array_vpn_get_proxy(uint32_t *ip, uint16_t *port);
    ARRAYAPI_DECL int  array_vpn_set_proxy(proxy_type_t type, const char *ip, uint16_t port, const char *user, const char *pass, const char *domain);

    ARRAYAPI_DECL int  array_vpn_sms_resend();

    #define VPN_DOWNLOAD_USE_TUNNEL_SSL 1
    ARRAYAPI_DECL int  array_vpn_download_file(vpn_vsite_conn_t conn, const char *url, uint32_t options, const char *path);
    ARRAYAPI_DECL int  array_vpn_download_cs_file(const char *filename, const char *output_path);

    ARRAYAPI_DECL int  array_vpn_reconnect();
    ARRAYAPI_DECL int  array_vpn_logout();
    ARRAYAPI_DECL int  array_vpn_get_auth_info(aaa_auth_info_t *info);
    ARRAYAPI_DECL int  array_vpn_is_session_valid();
    ARRAYAPI_DECL int  array_vpn_get_tunnel_socket(int *fd);
    ARRAYAPI_DECL int  array_vpn_otp_get_value(uint32_t now, const uint8_t *secret, int len);
    ARRAYAPI_DECL int  array_vpn_otp_encode_data(const uint8_t *data, int len, char *result, int result_len);

#ifdef __cplusplus
}
#endif

