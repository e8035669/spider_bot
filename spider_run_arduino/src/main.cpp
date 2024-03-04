#include <Arduino.h>
#include <Wire.h>

#include "Adafruit_PWMServoDriver.h"
#include "CommandParser.h"

#define DEFAULT_USMIN 600
#define DEFAULT_USMAX 2400
#define DEFAULT_SERVOMIN 123  // 600 / 20000 * 4096
#define DEFAULT_SERVOMAX 491  // 2400 / 20000 * 4096
#define SERVO_FREQ 50         // Analog servos run at ~50 Hz updates

#define N_PWMS 2

typedef CommandParser<> MyCommandParser;

struct PwmLimit {
  int min = DEFAULT_SERVOMIN;
  int max = DEFAULT_SERVOMAX;
};

struct Settings {
  PwmLimit limits[16 * N_PWMS] = {};
};

MyCommandParser parser;
// Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver(0x40);
Adafruit_PWMServoDriver pwms[N_PWMS] = {Adafruit_PWMServoDriver(0x40),
                                        Adafruit_PWMServoDriver(0x41)};
Settings settings = Settings();

void reset_pwm(Adafruit_PWMServoDriver& cur_pwm) {
  for (int i = 0; i < 16; ++i) {
    cur_pwm.setPWM(i, 0, 4096);
  }
}

void write_pwm(Adafruit_PWMServoDriver& cur_pwm, uint16_t pin, PwmLimit& limit,
               int16_t deg) {
  int16_t val = 4096;
  if (deg >= 0 && deg <= 180) {
    val = map(deg, 0, 180, limit.min, limit.max);
  }
  // Serial.print("set pwm ");
  // Serial.print(pin);
  // Serial.print(" ");
  // Serial.print(val);
  // Serial.print(" ");
  // Serial.println(deg);
  cur_pwm.setPWM(pin, 0, val);
}

bool write_pwm_all(uint16_t pin, int16_t deg) {
  if (pin < 16 * N_PWMS) {
    uint16_t pwm_idx = pin / 16;
    uint16_t pwm_pin = pin % 16;
    write_pwm(pwms[pwm_idx], pwm_pin, settings.limits[pin], deg);
    return true;
  }
  return false;
}

void cmd_write(MyCommandParser::Argument* args, char* response) {
  uint16_t pin = args[0].asUInt64;
  int16_t deg = args[1].asInt64;
  bool ret = write_pwm_all(pin, deg);
  if (ret) {
    strlcpy(response, "success", MyCommandParser::MAX_RESPONSE_SIZE);
  } else {
    strlcpy(response, "fail", MyCommandParser::MAX_RESPONSE_SIZE);
  }
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

  // for (int i = 0; i < 16; ++i) {
  //   PwmLimit& limit = settings.limits[i];
  //   Serial.print(limit.min);
  //   Serial.print("\t");
  //   Serial.println(limit.max);
  // }
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