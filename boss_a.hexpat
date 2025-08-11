#pragma author PretendoNetwork
#pragma description BOSS_A.db database
#pragma magic [ 00 80 34 12 ] @ 0x00
#pragma endian little

#include <std/mem.pat>

struct BOSS_A_EntryHeader {
    u64 appId;
    bool valid;
    u8 version; // expected version 3
    padding[6]; // probably?
};

enum MediaType : u8 {
    NAND,
    SD
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

struct BOSS_A_TitleInfo {
    u64 appId;
    u8 sessionMakerMaybe; // ? 1: user, 2: privileged
    bool optoutFlag;
    bool arrivalFlag;
    u8 unk_0x7[5]; // ?
    StorageEntry storage;
    u8 unk_0x30[0xF0];
};

struct BOSS_A_Certs {
    // Stubbed, the cert count is broken
    u8 rootCaCount;
    padding[3];
    char rootCaPath[0x100];
    char clientCertPath[0x100];
    char clientCertKeyPath[0x100];
};

struct BOSS_A_Entry {
    BOSS_A_EntryHeader header;
    BOSS_A_TitleInfo titleInfo;
    BOSS_A_Certs certs;
    u32 unk2; // unused ?
    padding[0x3C8];
};

struct BOSS_A_Data {
    u32 magic;
    BOSS_A_Entry entries[while(!std::mem::eof())];
};

BOSS_A_Data data @ 0x0;