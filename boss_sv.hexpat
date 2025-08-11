#pragma author PretendoNetwork
#pragma description BOSS_SV.db database
#pragma magic [ 00 80 34 12 ] @ 0x00
#pragma endian little

#include <std/mem.pat>

/// Represents the priority of a task
enum PriorityLevel : u8 {
    PriorityLevelExpedite1 = 0x15,
    PriorityLevelExpedite2,
    PriorityLevelExpedite3,
    PriorityLevelExpedite4,
    PriorityLevelExpedite5,
    PriorityLevelExpedite6,
    PriorityLevelExpedite7,
    PriorityLevelExpedite8,

    PriorityLevelExpedite = 0x23,

    PriorityLevelHigh = 0x50,

    PriorityLevelMedium = 0x7D,

    PriorityLevelLow = 0xAA,

    PriorityLevelLowest = 0xD7,

    PriorityLevelLowest1 = 0xDD,
    PriorityLevelLowest2,
    PriorityLevelLowest3,
    PriorityLevelLowest4,
    PriorityLevelLowest5,
    PriorityLevelLowest6,
    PriorityLevelLowest7,
    PriorityLevelLowest8,

    PriorityLevelStopped = 0xFF
};

/// Contains the configuration for a task policy
struct TaskPolicyConfig {
    /// Priority of the task
    PriorityLevel priority;
    /// This parameter is unknown. Must be 1
    u8 schedulingPolicy;
    /// This parameter is unknown. Must be below 4 (not inclusive)
    u8 taskPermission;
    /// This parameter is unknown. Seems unused?
    u8 unk_0x3;
    /// This parameter is unknown. Must be below 0x10000
    u32 taskTargetDuration;
    /// Interval in seconds of the task
    u32 interval;
    /// Number of times that the task will be run. If zero, the task is persistent
    u32 count;
};

/// Information about the status of a task
struct TaskStatusInfo {
    /// Number of seconds since the year 2000 of the last successful run of the task
    u64 lastSuccessfulTimestamp;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x29
    u64 property0x29;
    /// State code of the task
    u8 stateCode;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x1E
    u8 property0x1E;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x1F
    u8 property0x1F;
    /// Service status of the task
    u8 serviceStatus;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x22
    u8 property0x22;
    /// Result code of the task
    u8 result;
    padding[2];
    /// Received HTTP status code when performing the task. Set to 0 for successful codes
    u32 commErrorCode;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x25
    u32 property0x25;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x26
    u32 property0x26;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x27
    u32 property0x27;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x2A
    u32 property0x2A;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x2B
    u32 property0x2B;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x2D
    u16 property0x2D;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x2E
    u16 property0x2E;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x2C
    u8 property0x2C;
    /// This parameter is unknown. Matches with @link PropertyType @endlink 0x24
    u8 property0x24;
    padding[2];
    /// Date string from the Last-Modified HTTP header received when executing the task
    char lastModifiedHeader[0x40];
};

struct BOSS_SV_EntryHeader {
    u8 magic[3]; // [ 0x41, 0x01, 0x01 ]
    // The version is probably part of the magic too
    u8 version; // expected version 3
    padding[0xC];
    u64 appId;
    char taskId[8];
};

struct BOSS_SV_Unk1 {
    u8 unk_0x0[3]; // ?
    u8 taskType; // 0: Normal, 1: Immediate, 2: Background immediate
    u32 unk_0x4;
    u32 unk_0x8; // ?
    u32 unk_0xC;
    u8 unk_0x10[0x10];
    char timestamp[0x40]; // Is the size correct?
    u8 unk_0x60[0x180];
};

enum MediaType : u8 {
    NAND,
    SD,
};

struct StorageEntry {
    bool registered;
    MediaType mediaType;
    u16 entryId; // probably?
    u32 storageSize;
    u64 extdataId;
    u8 unk_0x20;
    padding[3];
    u32 unk_0x24;
    u16 unk_0x28;
    u16 unk_0x2A;
    u8 unk_0x2C[4];
};

struct BOSS_SV_Unk2 {
    u32 unk_0x0; // ?
    u32 unk_0x4;
    u8 unk_0x8[0x220];
    StorageEntry storage;
    u8 unk_0x248[0x360];
};

struct BOSS_SV_Unk3 {
    u32 unk_0x0;
    u32 unkResult;
    u32 unk_0x8;
    u8 unk_0xC[0xFC]; // padding?
};

struct BOSS_SV_Entry {
    BOSS_SV_EntryHeader header;
    TaskPolicyConfig policy;
    TaskStatusInfo status;
    BOSS_SV_Unk1 unk1;
    BOSS_SV_Unk2 unk2;
    BOSS_SV_Unk3 unk3;
    padding[0x2C8];
};

struct BOSS_SV_Data {
    u32 magic;
    BOSS_SV_Entry entries[while(!std::mem::eof())];
};

BOSS_SV_Data data @ 0x0;