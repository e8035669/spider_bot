#include <EEPROM.h>

// uint32_t eeprom_crc() {
//   const uint32_t crc_table[16] = {
//       0x00000000, 0x1db71064, 0x3b6e20c8, 0x26d930ac,  //
//       0x76dc4190, 0x6b6b51f4, 0x4db26158, 0x5005713c,  //
//       0xedb88320, 0xf00f9344, 0xd6d6a3e8, 0xcb61b38c,  //
//       0x9b64c2b0, 0x86d3d2d4, 0xa00ae278, 0xbdbdf21c};

//   uint32_t crc = ~0L;
//   for (uint16_t index = 0; index < EEPROM.length() - sizeof(uint32_t);
//        ++index) {
//     crc = crc_table[(crc ^ EEPROM[index]) & 0x0f] ^ (crc >> 4);
//     crc = crc_table[(crc ^ (EEPROM[index] >> 4)) & 0x0f] ^ (crc >> 4);
//     crc = ~crc;
//   }
//   return crc;
// }

// void eeprom_crc_put(uint32_t crc) {
//   uint16_t addr = EEPROM.length() - sizeof(uint32_t);
//   EEPROM.put(addr, crc);
// }

// uint32_t eeprom_crc_get() {
//   uint16_t addr = EEPROM.length() - sizeof(uint32_t);
//   uint32_t expect_crc = 0;
//   EEPROM.get(addr, expect_crc);
//   return expect_crc;
// }

// void eeprom_crc_save() {
//   uint32_t crc = eeprom_crc();
//   eeprom_crc_put(crc);
// }

// bool eeprom_crc_check() {
//   uint32_t expect_crc = eeprom_crc_get();
//   uint32_t crc = eeprom_crc();
//   return expect_crc == crc;
// }

uint32_t calc_crc(const void* ptr, uint16_t length) {
  const uint32_t crc_table[16] = {
      0x00000000, 0x1db71064, 0x3b6e20c8, 0x26d930ac,  //
      0x76dc4190, 0x6b6b51f4, 0x4db26158, 0x5005713c,  //
      0xedb88320, 0xf00f9344, 0xd6d6a3e8, 0xcb61b38c,  //
      0x9b64c2b0, 0x86d3d2d4, 0xa00ae278, 0xbdbdf21c};

  const uint8_t* data = reinterpret_cast<const uint8_t*>(ptr);

  uint32_t crc = ~0L;
  for (uint16_t index = 0; index < length; ++index) {
    crc = crc_table[(crc ^ data[index]) & 0x0f] ^ (crc >> 4);
    crc = crc_table[(crc ^ (data[index] >> 4)) & 0x0f] ^ (crc >> 4);
    crc = ~crc;
  }
  return crc;
}

uint32_t calc_eeprom_crc(uint16_t idx, uint16_t length) {
  const uint32_t crc_table[16] = {
      0x00000000, 0x1db71064, 0x3b6e20c8, 0x26d930ac,  //
      0x76dc4190, 0x6b6b51f4, 0x4db26158, 0x5005713c,  //
      0xedb88320, 0xf00f9344, 0xd6d6a3e8, 0xcb61b38c,  //
      0x9b64c2b0, 0x86d3d2d4, 0xa00ae278, 0xbdbdf21c};

  uint32_t crc = ~0L;
  for (uint16_t index = 0; index < length; ++index) {
    crc = crc_table[(crc ^ EEPROM[idx + index]) & 0x0f] ^ (crc >> 4);
    crc = crc_table[(crc ^ (EEPROM[idx + index] >> 4)) & 0x0f] ^ (crc >> 4);
    crc = ~crc;
  }
  return crc;
}