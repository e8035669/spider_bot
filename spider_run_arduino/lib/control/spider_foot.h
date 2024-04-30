#ifndef _SPIDER_FOOT_H_
#define _SPIDER_FOOT_H_

#include "Adafruit_PWMServoDriver.h"
#include "spider_result.h"

#define DEFAULT_FOOT_MIN 123  // 600 / 20000 * 4096
#define DEFAULT_FOOT_MAX 491  // 2400 / 20000 * 4096

#define HARDWARE_LIMIT_MIN 123
#define HARDWARE_LIMIT_MAX 491  // always limit in this range

// 定義一個可動關節的設定，包含最大與最小位置
struct SpiderFootSetting {
  int16_t min_val;
  int16_t max_val;
  SpiderFootSetting();
  SpiderFootSetting(int16_t min_val, int16_t max_val);
};

// 定義一個可動關節的腳位位置，是在哪個板子上及哪個pin腳
struct SpiderFootDef {
  Adafruit_PWMServoDriver& pwm;
  uint8_t pin;
  SpiderFootDef(Adafruit_PWMServoDriver& pwm, uint8_t pin);
};

// 定義一個可動關節，包含設定及腳位，實作一個可動關節的行為
class SpiderFoot {
  Adafruit_PWMServoDriver& pwm;
  uint8_t pin;
  SpiderFootSetting setting;

 public:
  SpiderFoot(SpiderFootDef foot_def);
  SpiderFoot(SpiderFootDef foot_def, SpiderFootSetting setting);

  void update_setting(SpiderFootSetting setting);

  SpiderFootSetting get_setting();

  void write_raw_deg(int16_t deg);

  void write(int16_t deg);
};

// 將某塊板子的所有腳位關閉
void reset_pwm(Adafruit_PWMServoDriver& cur_pwm);

// 可控制任何pin腳轉到指定角度
void write_pwm(Adafruit_PWMServoDriver& cur_pwm, uint16_t pin,
               SpiderFootSetting& limit, int16_t deg);

#endif