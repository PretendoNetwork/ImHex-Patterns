#pragma author PretendoNetwork
#pragma description BOSS data for Tomodachi Life
#pragma endian little

struct TomodachiLifeData {
    u32 unk_0x0;
    char16 author[0xB];
    u16 unk_0x1A;
    u32 crc32; // Standard CRC-32 of previous content
};

TomodachiLifeData data @ 0x0;