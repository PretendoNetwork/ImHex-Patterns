#pragma author PretendoNetwork
#pragma description BOSS data for Nintendo Badge Arcade - playinfo
#pragma endian little

struct PlayInfoRotation {
    u32 decimal_timestamp; // Decimal representation: YYmmddhhmm
    u32 unk_0x4;
    u32 begin_time; // Unix timestamp
    u32 end_time; // Unix timestamp
    u32 unk_0x10;
};

struct PlayInfoMinRotation {
    u32 decimal_timestamp; // Decimal representation: YYmmddhhmm
    u32 begin_time; // Unix timestamp
    u32 end_time; // Unix timestamp
};

struct PlayInfoUnkStruct {
    u32 unk_0x0;
    u32 unk_0x4; // May be related to a category ID?
    u32 unk_0x8; // May be related to a category ID?
};

struct PlayInfoHallAdRotation {
    u32 decimal_timestamp; // Decimal representation: YYmmddhhmm
    u32 begin_time; // Unix timestamp
    u32 end_time; // Unix timestamp
    u32 unk_0xC;
    u32 unk_0x10; // Looks like it adds an additional ad?
    u32 unk_0x14;
    u32 unk_0x18;
};

struct PlayInfoItemCode {
    char code[0x20];
};

struct PlayInfoItemCode2 {
    char id[0x20];
    u32 unk_0x20; // Values: 5, 10, 15, 20
};

struct PlayInfoISOName {
    char name[2];
};

struct PlayInfoString {
    u32 size;
    char16 string[size]; // Not NULL-terminated
};

struct PlayInfoCurrencyDisplay {
        PlayInfoString currency_before_number; // Example: $100
        PlayInfoString thousands_separator;
        PlayInfoString decimal_separator;
        PlayInfoString currency_after_number; // Example: 100$
};

struct PlayInfoCountry<auto languages_count> {
    PlayInfoISOName name;
    u32 purchase_plays_amount;
    u32 currency_value; // Conversion of $100 USD to the local currency
    u32 decimals_amount;
    u32 currency_value_with_decimals;
    PlayInfoCurrencyDisplay currency_displays[languages_count];
};

struct PlayInfoI18n {
    u32 language_count;
    PlayInfoISOName languages[language_count];
    u32 countries_count;
    PlayInfoCountry<language_count> countries[countries_count];
};

struct PlayInfo {
    u32 version; // Must be 5
    u32 unk_0x4; // Must be 5
    u32 unk_0x8;
    u32 daily_practice_plays;
    u32 unk_0x10;
    u32 unk_0x14;
    u32 unk_0x18;
    u32 unk_0x1C;
    u32 unk_0x20;
    u32 unk_0x24;
    u32 unk_0x28;
    u32 rotations_count;
    PlayInfoRotation rotations[rotations_count];
    u32 unk_min_rotations_count;
    PlayInfoMinRotation unk_min_rotations[unk_min_rotations_count];
    PlayInfoUnkStruct unk_0xCC[4];
    u32 unk_0xFC;
    u64 unk_0x100; // Is this really a u64? This is all 0xFF
    u32 hall_ad_rotations_count;
    PlayInfoHallAdRotation hall_ad_rotations[hall_ad_rotations_count];
    PlayInfoItemCode eshop_item_codes[4];
    u32 hall_catcher_sale; // Shows the "sale" catcher when not zero
    u32 eshop_item_codes_2_count;
    PlayInfoItemCode2 eshop_item_codes_2[eshop_item_codes_2_count];
    PlayInfoI18n i18n;
    u8 hmac_sha256[0x20]; // Hash of previous content. Key: "51112e9732166c4f650daae1f1d04e45"
};

PlayInfo info @ 0x0;