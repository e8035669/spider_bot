#include "spider_foot.h"

SpiderFootSetting::SpiderFootSetting()
    : min_val(DEFAULT_FOOT_MIN), max_val(DEFAULT_FOOT_MAX) {}

SpiderFootSetting::SpiderFootSetting(int16_t min_val, int16_t max_val)
    : min_val(min_val), max_val(max_val) {}

SpiderFootDef::SpiderFootDef(Adafruit_PWMServoDriver& pwm, uint8_t pin)
    : pwm(pwm), pin(pin) {}

SpiderFoot::SpiderFoot(SpiderFootDef foot_def)
    : SpiderFoot(foot_def, SpiderFootSetting()) {}

SpiderFoot::SpiderFoot(SpiderFootDef foot_def, SpiderFootSetting setting)
    : pwm(foot_def.pwm), pin(foot_def.pin), setting(setting) {}

void SpiderFoot::update_setting(SpiderFootSetting setting) {
  this->setting = setting;
}

SpiderFootSetting SpiderFoot::get_setting() { return this->setting; }

void SpiderFoot::write_raw_deg(int16_t deg) {
  int16_t val = 4096;
  if (deg >= 0 && deg <= 180) {
    val = map(deg, 0, 180, DEFAULT_FOOT_MIN, DEFAULT_FOOT_MAX);
    val = constrain(val, HARDWARE_LIMIT_MIN, HARDWARE_LIMIT_MAX);
  }
  pwm.setPWM(pin, 0, val);
}

void SpiderFoot::write(int16_t deg) {
  int16_t val = 4096;
  if (deg >= 0 && deg <= 180) {
    val = map(deg, 0, 180, setting.min_val, setting.max_val);
    val = constrain(val, HARDWARE_LIMIT_MIN, HARDWARE_LIMIT_MAX);
  }
  pwm.setPWM(pin, 0, val);
}

void reset_pwm(Adafruit_PWMServoDriver& cur_pwm) {
  for (int i = 0; i < 16; ++i) {
    cur_pwm.setPWM(i, 0, 4096);
  }
}

void write_pwm(Adafruit_PWMServoDriver& cur_pwm, uint16_t pin,
               SpiderFootSetting& limit, int16_t deg) {
  int16_t val = 4096;
  if (deg >= 0 && deg <= 180) {
    val = map(deg, 0, 180, limit.min_val, limit.max_val);
  }
  // Serial.print("set pwm ");
  // Serial.print(pin);
  // Serial.print(" ");
  // Serial.print(val);
  // Serial.print(" ");
  // Serial.println(deg);
  cur_pwm.setPWM(pin, 0, val);
}
