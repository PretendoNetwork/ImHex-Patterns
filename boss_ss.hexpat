#pragma author PretendoNetwork
#pragma description BOSS_SS.db database
#pragma magic [ 00 80 34 12 ] @ 0x00
#pragma endian little

#define constexpr
#define int u32

#include <std/mem.pat>

constexpr int ACTION_DATA_SIZE = 0x200;
constexpr int URL_SIZE = 0x200;
constexpr int HTTP_HEADER_SIZE = 0x20;
constexpr int HTTP_HEADER_VALUE_SIZE = 0x100;
constexpr int MAX_HEADERS = 3;
constexpr int MAX_ROOT_CAS = 3;
constexpr int MAX_CLIENT_CERTS = 1;

constexpr int TASK_ID_SIZE = 8;
constexpr int TASK_ID_LIST_SIZE = 128;

constexpr int QUERY_NAME_SIZE = 0xF;
constexpr int QUERY_VALUE_SIZE = 0x10;
constexpr int MAX_QUERY_FIELDS = 3;

constexpr u8 STEP_ID_CURRENT = 0x80;
constexpr int STEP_ID_LIST_SIZE = 0x80;

/// Represents an action that a task will perform
enum ActionCode : u8 {
    /// Action code used for listing files on the BOSS server. May be a generic raw download?
    ActionCodeFileList = 0x1,
    /// Action code for downloading data from the given URL, principally an @link NsData @endlink
    ActionCodeNsaDownload,
    /// Action code for uploading data to the given URL
    ActionCodeUpload,
    /// Unknown action code
    ActionCodeUnknown0x4,
    /// Unknown action code
    ActionCodeUnknown0x5,
    /// Action code used by task ID "pl" from the Home Menu
    ActionCodePl,
    /// Action code used by task ID "phu" from the Home Menu
    ActionCodePhu,
    /// Action code used by task ID "tiu" from the Home Menu
    ActionCodeTiu,
    /// Action code used by task ID "splu" from the Home Menu
    ActionCodeSplu,
    /// Action code used for downloading data from DataStore through an Hpp server. Stores notification data?
    ActionCodeDataStoreDownload,
    /// Action code related to DataStore?
    ActionCodeDataStore2,
    /// Action code used for StreetPass Relay
    ActionCodeSPRelay,
    /// Action code used for downloading the title version list (versionList.dat)
    ActionCodeVersionList
};

/// Flags which add additional information related to the console's access point to the data sent to the server
bitfield ApInfoType {
    /// Adds the "apgroup" parameter to the query
    bool ApInfoTypeApGroup : 1;
    /// Adds the "aparea" parameter to the query
    bool ApInfoTypeApArea : 1;
    /// Adds the "ap" parameter to the query
    bool ApInfoTypeAp : 1;
};

/// Flags which add additional information related to the console's configuration to the data sent to the server
bitfield CfgInfoType {
    /// Adds the "c" parameter to the query
    bool CfgInfoTypeCountry : 1;
    /// Adds the "l" parameter to the query
    bool CfgInfoTypeLanguage : 1;
    /// Adds the "tm" parameter to the query
    bool CfgInfoTypeTargetModel : 1;
};

// UNOFFICIAL: The official name of this struct is unknown
struct HeaderField {
    char header[HTTP_HEADER_SIZE];
    char value[HTTP_HEADER_VALUE_SIZE];
};

/// Contains the configuration for a task action
struct TaskActionConfig {
    /// Code for the action to perform
    ActionCode code;
    /// If non-zero, enables the task root CA to be read from the filesystem. May be a bool?
    u8 fsRootCA;
    /// If non-zero, enables the task client certificate to be read from the filesystem. May be a bool?
    u8 fsClientCert;
    /// See @link ApInfoType @endlink. Must be between 0 and 7 inclusively
    ApInfoType apInfoType;
    /// This parameter is unknown. Must be between 0 and 6 inclusively. Controls what data is relevant? Matches with @link PropertyType @endlink 0x9
    u8 property0x9;
    /// See @link CfgInfoType @endlink. Must be between 0 and 7 inclusively
    CfgInfoType cfgInfoType;
    padding[2];
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x16
    u32 property0x16;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x8
    u32 property0x8;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x3B
    u32 property0x3B;
    /// Contains a file handle with the data to send
    u32 fileHandle;
    /// Additional data for the action. The contents depend on the @link ActionCode @endlink used
    u8 actionData[ACTION_DATA_SIZE];
    /// Target URL where the contents are sent. Unused for DataStore actions
    char url[URL_SIZE];
    /// Additional headers to include in the request sent to the server
    HeaderField headerFields[MAX_HEADERS];
    /// Array of Root CA IDs to be used when connecting to the server
    u32 rootCAs[MAX_ROOT_CAS];
    /// Array of client certificate IDs to be used when connecting to the server
    u32 clientCerts[MAX_CLIENT_CERTS];
    /// Amount of Root CAs stored in the previous array
    u32 rootCaCount;
    /// Amount of client certificates stored in the previous array
    u32 clientCertCount;
    u32 unk_0x790;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x15
    u8 property0x15[0x40];
};

/// Configuration of task options
struct TaskOptionConfig {
    /// This parameter is unknown. Must be 1. Matches with @link PropertyType @endlink 0x18
    u8 property0x18;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x19
    u8 property0x19;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x1A
    u8 property0x1A;
    padding[1];
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x1B
    u32 property0x1B;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x1C
    u32 property0x1C;
};

/// Represents a field of a query
struct QueryField {
    bool used;
    char name[QUERY_NAME_SIZE];
    char value[QUERY_VALUE_SIZE];
};

struct TaskQueryConfig {
    QueryField fields[MAX_QUERY_FIELDS];
};

struct BOSS_SS_EntryHeader {
    u8 version; // expected version 3
    padding[3];
};

struct BOSS_SS_Entry {
    BOSS_SS_EntryHeader header;
    TaskActionConfig taskAction;
    TaskOptionConfig taskOption;
    TaskQueryConfig query;
    padding[0x3BC];
};

struct BOSS_SS_Data {
    u32 magic;
    BOSS_SS_Entry entries[while(!std::mem::eof())];
};

BOSS_SS_Data data @ 0x0;