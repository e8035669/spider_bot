#ifndef _EEPROM_CRC_H_
#define _EEPROM_CRC_H_

#include <stdint.h>

uint32_t calc_crc(const void* ptr, uint16_t length);
uint32_t calc_eeprom_crc(uint16_t idx, uint16_t length);

template <typename T>
void eeprom_crc_put(int idx, const T& t) {
  uint32_t crc = calc_crc(&t, sizeof(T));
  EEPROM.put(idx, t);
  idx += sizeof(T);
  EEPROM.put(idx, crc);
}

template <typename T>
bool eeprom_crc_get(uint16_t idx, T& t) {
  uint16_t crc_addr = idx + sizeof(T);
  uint32_t expect_crc = 0;
  EEPROM.get(crc_addr, expect_crc);
  uint32_t eeprom_crc = calc_eeprom_crc(idx, sizeof(T));
  if (expect_crc == eeprom_crc) {
    EEPROM.get(idx, t);
    return true;
  } else {
    return false;
  }
}

#endif