#ifndef _SPIDER_CONTROL_H_
#define _SPIDER_CONTROL_H_

#include "spider_foot.h"
#include "spider_result.h"

#define N_FEET 18

// 定義一隻蜘蛛的設定，有18個關節
struct SpiderControlConf {
  SpiderFootDef defs[N_FEET];
};

// 定義一隻蜘蛛的行為
class SpiderControl {
  SpiderFoot feet[N_FEET];

 public:
  SpiderControl(SpiderControlConf conf);

  SpiderResult write_one_deg(uint8_t pin, int16_t deg);
  SpiderResult write_one_raw_deg(uint8_t pin, int16_t deg);

  SpiderResult update_setting(uint8_t pin, SpiderFootSetting setting);
  SpiderResult update_setting_center(uint8_t pin, int16_t center_deg,
                                     int16_t multiply);
  SpiderFootSetting get_setting(uint8_t pin);
};

#endif
