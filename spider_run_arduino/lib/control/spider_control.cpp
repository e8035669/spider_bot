#include "spider_control.h"

#include "Adafruit_PWMServoDriver.h"

SpiderControl::SpiderControl(SpiderControlConf conf)
    : feet{
          SpiderFoot(conf.defs[0], SpiderFootSetting()),
          SpiderFoot(conf.defs[1], SpiderFootSetting()),
          SpiderFoot(conf.defs[2], SpiderFootSetting()),
          SpiderFoot(conf.defs[3], SpiderFootSetting()),
          SpiderFoot(conf.defs[4], SpiderFootSetting()),
          SpiderFoot(conf.defs[5], SpiderFootSetting()),
          SpiderFoot(conf.defs[6], SpiderFootSetting()),
          SpiderFoot(conf.defs[7], SpiderFootSetting()),
          SpiderFoot(conf.defs[8], SpiderFootSetting()),
          SpiderFoot(conf.defs[9], SpiderFootSetting()),
          SpiderFoot(conf.defs[10], SpiderFootSetting()),
          SpiderFoot(conf.defs[11], SpiderFootSetting()),
          SpiderFoot(conf.defs[12], SpiderFootSetting()),
          SpiderFoot(conf.defs[13], SpiderFootSetting()),
          SpiderFoot(conf.defs[14], SpiderFootSetting()),
          SpiderFoot(conf.defs[15], SpiderFootSetting()),
          SpiderFoot(conf.defs[16], SpiderFootSetting()),
          SpiderFoot(conf.defs[17], SpiderFootSetting()),
      } {}

SpiderResult SpiderControl::write_one_deg(uint8_t pin, int16_t deg) {
  if (pin < N_FEET) {
    feet[pin].write(deg);
    return SpiderResult::SUCCESS;
  }
  return SpiderResult::INVALID_PIN;
}

SpiderResult SpiderControl::write_one_raw_deg(uint8_t pin, int16_t deg) {
  if (pin < N_FEET) {
    feet[pin].write_raw_deg(deg);
    return SpiderResult::SUCCESS;
  }
  return SpiderResult::INVALID_PIN;
}

SpiderResult SpiderControl::update_setting(uint8_t pin,
                                           SpiderFootSetting setting) {
  if (pin < N_FEET) {
    feet[pin].update_setting(setting);
    return SpiderResult::SUCCESS;
  }
  return SpiderResult::INVALID_PIN;
}

SpiderResult SpiderControl::update_setting_center(uint8_t pin,
                                                  int16_t center_deg,
                                                  int16_t multiply) {
  if (pin >= N_FEET) {
    return SpiderResult::INVALID_PIN;
  }
  if (center_deg < 0 || center_deg > 180) {
    return SpiderResult::INVALID_DEG;
  }
  if (multiply < -2000 || multiply > 2000) {
    return SpiderResult::INVALID_MULTIPLY;
  }
  const static int32_t default_length =
      (DEFAULT_FOOT_MAX - DEFAULT_FOOT_MIN) / 2;
  int32_t length = (default_length * multiply) / 1000;
  int16_t center = map(center_deg, 0, 180, DEFAULT_FOOT_MIN, DEFAULT_FOOT_MAX);
  int16_t new_min = center - length;
  int16_t new_max = center + length;
  SpiderFootSetting new_setting(new_min, new_max);
  SpiderResult ret = this->update_setting(pin, new_setting);
  return ret;
}

SpiderFootSetting SpiderControl::get_setting(uint8_t pin) {
  if (pin < N_FEET) {
    return feet[pin].get_setting();
  }
  return SpiderFootSetting();
}
