use anyhow::{anyhow, Ok};
use anyhow::{Context, Result};
use serialport::{self, SerialPort};
use std::io::prelude::*;
use std::io::BufReader;
use std::sync::{Arc, Mutex};
use std::thread::sleep;
use std::time::Duration;

pub fn list_ports() -> Result<Vec<String>> {
    let ports = serialport::available_ports().with_context(|| "List ports error")?;
    let ret = ports.iter().map(|p| p.port_name.to_owned()).collect();
    Ok(ret)
}

pub trait SerialInterface: Send {
    fn send_write_cmd(&mut self, pin: i32, deg: i32) -> Result<()>;
    fn update_setting(&mut self, pin: i32, center_deg: f64, multiply: f64) -> Result<()>;
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
    fn send_write_cmd(&mut self, pin: i32, deg: i32) -> Result<()> {
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

    fn update_setting(&mut self, pin: i32, center_deg: f64, multiply: f64) -> Result<()> {
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
}

// unsafe impl Sync for UsbSerial {}

pub struct MockSerialConnection {}

impl MockSerialConnection {
    fn create(device_name: &str) -> Result<Self> {
        println!("Mock create {}", device_name);
        sleep(Duration::from_secs(1));
        Ok(Self {})
    }
}

impl SerialInterface for MockSerialConnection {
    fn send_write_cmd(&mut self, pin: i32, deg: i32) -> Result<()> {
        sleep(Duration::from_millis(10));
        println!("Mock Write {} {}", pin, deg);
        Ok(())
    }

    fn update_setting(&mut self, pin: i32, center_deg: f64, multiply: f64) -> Result<()> {
        sleep(Duration::from_millis(10));
        println!("Mock update {} {} {}", pin, center_deg, multiply);
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

    pub fn send_write_cmd(&self, pin: i32, deg: i32) -> Result<()> {
        let mut comp = self.comp.lock().unwrap();
        match *comp {
            Some(ref mut comp) => {
                comp.send_write_cmd(pin, deg)?;
            }
            None => return Err(anyhow!("Serial not connect")),
        }
        Ok(())
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
