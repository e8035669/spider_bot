#include "spider_control.h"

#include "Adafruit_PWMServoDriver.h"

SpiderFootSettingCenter::SpiderFootSettingCenter()
    : center_deg(90), multiply(1000) {}

SpiderFootSettingCenter::SpiderFootSettingCenter(int16_t center_deg,
                                                 int16_t multiply)
    : center_deg(center_deg), multiply(multiply) {}

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

SpiderResult SpiderControl::write(uint8_t pin, int16_t deg) {
  if (pin < N_FEET) {
    feet[pin].write(deg);
    return SpiderResult::SUCCESS;
  }
  return SpiderResult::INVALID_PIN;
}

SpiderResult SpiderControl::write_raw_deg(uint8_t pin, int16_t deg) {
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

SpiderFootSettingCenter SpiderControl::get_setting_center(uint8_t pin) {
  if (pin >= N_FEET) {
    return SpiderFootSettingCenter();
  }
  SpiderFootSetting setting = this->get_setting(pin);
  const static int32_t default_length = (DEFAULT_FOOT_MAX - DEFAULT_FOOT_MIN);
  int32_t length = setting.max_val - setting.min_val;
  int16_t multiply = (length * 1000) / default_length;
  multiply = constrain(multiply, -2000, 2000);
  int16_t center_pulse = (setting.max_val + setting.min_val) / 2;
  int16_t center =
      map(center_pulse, DEFAULT_FOOT_MIN, DEFAULT_FOOT_MAX, 0, 180);
  center = constrain(center, 0, 180);
  SpiderFootSettingCenter ret(center, multiply);
  return ret;
}

SpiderFootStatus SpiderControl::get_status(uint8_t pin) {
  if (pin < N_FEET) {
    return feet[pin].get_status();
  }
  return SpiderFootStatus();
}
