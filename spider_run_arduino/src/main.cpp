#include <Arduino.h>
#include <Wire.h>

#include "Adafruit_PWMServoDriver.h"
#include "CommandParser.h"
#include "spider_control.h"
#include "spider_foot.h"

#define DEFAULT_USMIN 600
#define DEFAULT_USMAX 2400
#define DEFAULT_SERVOMIN 123  // 600 / 20000 * 4096
#define DEFAULT_SERVOMAX 491  // 2400 / 20000 * 4096
#define SERVO_FREQ 50         // Analog servos run at ~50 Hz updates

#define N_PWMS 2

typedef CommandParser<> MyCommandParser;

MyCommandParser parser;
// Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver(0x40);
Adafruit_PWMServoDriver pwms[2] = {Adafruit_PWMServoDriver(0x40),
                                   Adafruit_PWMServoDriver(0x41)};

SpiderControl spider(SpiderControlConf{{
    SpiderFootDef(pwms[0], 0),
    SpiderFootDef(pwms[0], 1),
    SpiderFootDef(pwms[0], 2),
    SpiderFootDef(pwms[0], 4),
    SpiderFootDef(pwms[0], 5),
    SpiderFootDef(pwms[0], 6),
    SpiderFootDef(pwms[0], 8),
    SpiderFootDef(pwms[0], 9),
    SpiderFootDef(pwms[0], 10),
    SpiderFootDef(pwms[1], 0),
    SpiderFootDef(pwms[1], 1),
    SpiderFootDef(pwms[1], 2),
    SpiderFootDef(pwms[1], 4),
    SpiderFootDef(pwms[1], 5),
    SpiderFootDef(pwms[1], 6),
    SpiderFootDef(pwms[1], 8),
    SpiderFootDef(pwms[1], 9),
    SpiderFootDef(pwms[1], 10),
}});

SpiderResult write_pwm_all(uint16_t pin, int16_t deg) {
  SpiderResult ret = spider.write_one_deg((uint8_t)pin, deg);
  return ret;
}

void cmd_write(MyCommandParser::Argument* args, char* response) {
  uint16_t pin = args[0].asUInt64;
  int16_t deg = args[1].asInt64;
  SpiderResult ret = write_pwm_all(pin, deg);
  // itoa((int)ret, response, 10);
  sprintf(response, "%d %d %d", ret, pin, deg);
}

SpiderResult update_setting(uint16_t pin, int16_t center_deg,
                            int16_t multiply) {
  SpiderResult ret = spider.update_setting_center(pin, center_deg, multiply);
  return ret;
}

void cmd_update(MyCommandParser::Argument* args, char* response) {
  uint16_t pin = args[0].asUInt64;
  int16_t center_deg = args[1].asInt64;
  int16_t multiply = args[2].asInt64;
  SpiderResult ret = update_setting(pin, center_deg, multiply);
  // itoa((int)ret, response, 10);
  sprintf(response, "%d %d %d %d", ret, pin, center_deg, multiply);
}

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < N_PWMS; ++i) {
    Adafruit_PWMServoDriver& pwm = pwms[i];
    pwm.begin();
    pwm.setOscillatorFrequency(25000000);
    pwm.setPWMFreq(SERVO_FREQ);  // Analog servos run at ~50 Hz updates
  }

  for (int i = 0; i < N_PWMS; ++i) {
    reset_pwm(pwms[i]);
  }

  parser.registerCommand("write", "ui", cmd_write);
  parser.registerCommand("update", "uii", cmd_update);
}

void loop() {
  if (Serial.available()) {
    char line[128];
    size_t lineLength = Serial.readBytesUntil('\n', line, 127);
    line[lineLength] = '\0';

    char response[MyCommandParser::MAX_RESPONSE_SIZE];
    parser.processCommand(line, response);
    Serial.println(response);
  }
}