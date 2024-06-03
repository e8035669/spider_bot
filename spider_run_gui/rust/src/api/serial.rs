use anyhow::{anyhow, Ok};
use anyhow::{Context, Result};
use serialport::{self, SerialPort};
use std::fmt::format;
use std::io::prelude::*;
use std::io::BufReader;
use std::sync::Mutex;
use std::thread::sleep;
use std::time::Duration;

pub fn list_ports() -> Result<Vec<String>> {
    let ports = serialport::available_ports().with_context(|| "List ports error")?;
    let ret = ports.iter().map(|p| p.port_name.to_owned()).collect();
    Ok(ret)
}

pub trait SerialInterface: Send {
    fn write(&mut self, pin: i32, deg: i32) -> Result<()>;
    fn update(&mut self, pin: i32, center_deg: f64, multiply: f64) -> Result<()>;
    fn get_setting(&mut self, pin: i32) -> Result<SpiderFootSetting>;
    fn get_status(&mut self, pin: i32) -> Result<SpiderFootStatus>;
    fn save(&mut self) -> Result<()>;
    fn reset(&mut self) -> Result<()>;
}

pub struct UsbSerial {
    conn: Box<dyn SerialPort>,
    reader: BufReader<Box<dyn SerialPort>>,
}

impl UsbSerial {
    fn create(device_name: &str) -> Result<Self> {
        let conn = serialport::new(device_name, 9600)
            .timeout(Duration::from_secs(10))
            .open()
            .with_context(|| format!("Open device {} failed", device_name))?;
        let conn_clone = conn.try_clone().with_context(|| "Serial clone failed")?;
        let reader = BufReader::new(conn_clone);
        let comp = UsbSerial { conn, reader };
        Ok(comp)
    }
}

impl SerialInterface for UsbSerial {
    fn write(&mut self, pin: i32, deg: i32) -> Result<()> {
        let cmd = format!("write {} {}\n", pin, deg);
        self.conn
            .write_all(cmd.as_bytes())
            .with_context(|| "Write cmd failed")?;

        let mut msg = String::new();
        let _ret = self.reader.read_line(&mut msg)?;
        let msg = msg.trim();
        println!("Get message {}", msg);
        Ok(())
    }

    fn update(&mut self, pin: i32, center_deg: f64, multiply: f64) -> Result<()> {
        let center_deg = center_deg.round() as i32;
        let multiply = (multiply * 1000.0).round() as i32;
        let cmd = format!("update {} {} {}\n", pin, center_deg, multiply);
        self.conn
            .write_all(cmd.as_bytes())
            .with_context(|| "Write cmd failed")?;
        let mut msg = String::new();
        let _ret = self.reader.read_line(&mut msg)?;
        let msg = msg.trim();
        println!("Get message {}", msg);
        Ok(())
    }

    fn get_setting(&mut self, pin: i32) -> Result<SpiderFootSetting> {
        let cmd = format!("getset {}\n", pin);
        self.conn
            .write_all(cmd.as_bytes())
            .with_context(|| "Write cmd failed")?;
        let mut msg = String::new();
        let _ret = self.reader.read_line(&mut msg)?;
        let tokens = msg
            .trim()
            .split(' ')
            .enumerate()
            .map(|(i, v)| {
                v.parse::<i32>()
                    .with_context(|| format!("parse getset response error getset[{}] = {}", i, v))
            })
            .collect::<Result<Vec<_>>>()?;
        if tokens.len() < 3 {
            return Err(anyhow!("invalid token length"));
        }
        let center_deg = tokens[1] as f64;
        let multiply = tokens[2] as f64 / 1000.0;
        let ret = SpiderFootSetting {
            center_deg,
            multiply,
        };

        Ok(ret)
    }

    fn get_status(&mut self, pin: i32) -> Result<SpiderFootStatus> {
        let cmd = format!("getsta {}\n", pin);
        self.conn
            .write_all(cmd.as_bytes())
            .with_context(|| "Write cmd failed")?;
        let mut msg = String::new();
        let _ret = self.reader.read_line(&mut msg)?;
        let tokens = msg
            .trim()
            .split(' ')
            .enumerate()
            .map(|(i, v)| {
                v.parse::<i32>()
                    .with_context(|| format!("parse getsta response error getsta[{}] = {}", i, v))
            })
            .collect::<Result<Vec<i32>>>()?;
        if tokens.len() < 4 {
            return Err(anyhow!("invalid token length"));
        }
        let enabled = tokens[1] > 0;
        let deg = tokens[2];
        let ret = SpiderFootStatus { enabled, deg };
        Ok(ret)
    }

    fn save(&mut self) -> Result<()> {
        let cmd = String::from("save\n");
        self.conn
            .write_all(cmd.as_bytes())
            .with_context(|| "Write cmd failed")?;
        let mut msg = String::new();
        let _ret = self.reader.read_line(&mut msg)?;
        if msg.trim() != "OK" {
            return Err(anyhow!("Remote not report OK"));
        }
        Ok(())
    }

    fn reset(&mut self) -> Result<()> {
        let cmd = String::from("reset\n");
        self.conn
            .write_all(cmd.as_bytes())
            .with_context(|| "Write cmd failed")?;
        let mut msg = String::new();
        let _ret = self.reader.read_line(&mut msg)?;
        if msg.trim() != "OK" {
            return Err(anyhow!("Remote not report OK"));
        }
        Ok(())
    }
}

// unsafe impl Sync for UsbSerial {}

#[derive(Clone, Copy, Debug)]
pub struct SpiderFootStatus {
    pub enabled: bool,
    pub deg: i32,
}

impl SpiderFootStatus {
    fn new() -> Self {
        Self {
            enabled: false,
            deg: 90,
        }
    }
}

#[derive(Clone, Copy, Debug)]
pub struct SpiderFootSetting {
    pub center_deg: f64,
    pub multiply: f64,
}

impl SpiderFootSetting {
    fn new() -> Self {
        Self {
            center_deg: 90.0,
            multiply: 1.0,
        }
    }
}

#[derive(Clone, Copy, Debug)]
pub struct MockSerialConnection {
    foot_status: [SpiderFootStatus; 18],
    foot_settings: [SpiderFootSetting; 18],
}

impl MockSerialConnection {
    fn new() -> Self {
        Self {
            foot_status: [SpiderFootStatus::new(); 18],
            foot_settings: [SpiderFootSetting::new(); 18],
        }
    }

    fn create(device_name: &str) -> Result<Self> {
        println!("Mock create {}", device_name);
        sleep(Duration::from_secs(1));
        Ok(Self::new())
    }

    fn reset_default(&mut self) {
        self.foot_settings = [SpiderFootSetting::new(); 18]
    }
}

impl SerialInterface for MockSerialConnection {
    fn write(&mut self, pin: i32, deg: i32) -> Result<()> {
        sleep(Duration::from_millis(10));
        let pin = pin as usize;
        if pin < self.foot_status.len() {
            if deg < 0 {
                self.foot_status[pin].enabled = false;
            } else {
                self.foot_status[pin].enabled = true;
                self.foot_status[pin].deg = deg;
            }
        }
        println!("Mock Write {} {}", pin, deg);
        Ok(())
    }

    fn update(&mut self, pin: i32, center_deg: f64, multiply: f64) -> Result<()> {
        sleep(Duration::from_millis(10));
        let pin = pin as usize;
        if pin < self.foot_settings.len() {
            self.foot_settings[pin].center_deg = center_deg;
            self.foot_settings[pin].multiply = multiply;
        }
        println!("Mock update {} {} {}", pin, center_deg, multiply);
        Ok(())
    }

    fn get_setting(&mut self, pin: i32) -> Result<SpiderFootSetting> {
        sleep(Duration::from_millis(10));
        let pin = pin as usize;
        if pin < self.foot_settings.len() {
            Ok(self.foot_settings[pin])
        } else {
            Err(anyhow!("pin should < 18"))
        }
    }

    fn get_status(&mut self, pin: i32) -> Result<SpiderFootStatus> {
        sleep(Duration::from_millis(10));
        let pin = pin as usize;
        if pin < self.foot_status.len() {
            Ok(self.foot_status[pin])
        } else {
            Err(anyhow!("pin should < 18"))
        }
    }

    fn save(&mut self) -> Result<()> {
        sleep(Duration::from_millis(10));
        Ok(())
    }

    fn reset(&mut self) -> Result<()> {
        sleep(Duration::from_millis(10));
        self.reset_default();
        Ok(())
    }
}

#[flutter_rust_bridge::frb(opaque)]
pub struct SerialConnection {
    comp: Mutex<Option<Box<dyn SerialInterface>>>,
}

impl SerialConnection {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new() -> Self {
        Self {
            comp: Mutex::new(None),
        }
    }

    pub fn is_connected(&self) -> bool {
        let comp = self.comp.lock().unwrap();
        comp.is_some()
    }

    pub fn connect(&self, device_name: &str, mock: bool) -> Result<()> {
        let mut comp = self.comp.lock().unwrap();
        if mock {
            *comp = Some(Box::new(MockSerialConnection::create(device_name)?));
        } else {
            *comp = Some(Box::new(UsbSerial::create(device_name)?));
        }
        println!("Connected to {}", device_name);
        Ok(())
    }

    pub fn disconnect(&self) -> Result<()> {
        let mut comp = self.comp.lock().unwrap();
        *comp = None;
        println!("Disconnected");
        Ok(())
    }

    pub fn write(&self, pin: i32, deg: i32) -> Result<()> {
        let mut comp = self.comp.lock().unwrap();
        let comp = comp
            .as_deref_mut()
            .ok_or_else(|| anyhow!("Serial not connect"))?;
        comp.write(pin, deg)?;
        Ok(())
    }

    pub fn update(&self, pin: i32, center_deg: f64, multiply: f64) -> Result<()> {
        let mut comp = self.comp.lock().unwrap();
        let comp = comp
            .as_deref_mut()
            .ok_or_else(|| anyhow!("Serial not connect"))?;
        comp.update(pin, center_deg, multiply)?;
        Ok(())
    }

    pub fn get_setting(&self, pin: i32) -> Result<SpiderFootSetting> {
        let mut comp = self.comp.lock().unwrap();
        let comp = comp
            .as_deref_mut()
            .ok_or_else(|| anyhow!("Serial not connect"))?;
        comp.get_setting(pin)
    }

    pub fn get_status(&self, pin: i32) -> Result<SpiderFootStatus> {
        let mut comp = self.comp.lock().unwrap();
        let comp = comp
            .as_deref_mut()
            .ok_or_else(|| anyhow!("Serial not connect"))?;
        comp.get_status(pin)
    }

    pub fn save(&self) -> Result<()> {
        let mut comp = self.comp.lock().unwrap();
        let comp = comp
            .as_deref_mut()
            .ok_or_else(|| anyhow!("Serial not connect"))?;
        comp.save()
    }

    pub fn reset(&self) -> Result<()> {
        let mut comp = self.comp.lock().unwrap();
        let comp = comp
            .as_deref_mut()
            .ok_or_else(|| anyhow!("Serial not connect"))?;
        comp.reset()
    }
}

// #[flutter_rust_bridge::frb(opaque)]
// pub struct Foo {
//     aaa: String,
//     bbb: Arc<Mutex<Option<Box<dyn SerialInterface + Send + Sync>>>>,
// }

// impl Foo {
//     pub fn new() -> Self {
//         Self {
//             aaa: String::from("123"),
//             bbb: Arc::new(Mutex::new(None)),
//         }
//     }
// }

// #[allow(dead_code)]
// fn assert_properties() {
//     fn is_send<T: Send>() {}
//     fn is_sync<T: Sync>() {}
//     fn is_send_sync<T: Send + Sync>() {}

//     is_send::<UsbSerial>();
//     is_send_sync::<Arc<Mutex<Box<dyn SerialPort>>>>();
//     is_send_sync::<Mutex<BufReader<Box<dyn SerialPort>>>>();
//     is_send_sync::<Mutex<UsbSerial>>();
// }
