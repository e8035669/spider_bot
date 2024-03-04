use anyhow::{Context, Result};
use serialport;
use std::io::prelude::*;
use std::io::BufReader;
use std::sync::Mutex;
use std::time::Duration;

pub fn list_ports() -> Result<Vec<String>> {
    let ports = serialport::available_ports().with_context(|| "List ports error")?;
    let ret = ports.iter().map(|p| p.port_name.to_owned()).collect();
    Ok(ret)
}

struct SerialComponents {
    conn: Box<dyn serialport::SerialPort>,
    reader: BufReader<Box<dyn serialport::SerialPort>>,
}

#[flutter_rust_bridge::frb(opaque)]
pub struct SerialConnection {
    comp: Mutex<SerialComponents>,
}

impl SerialConnection {
    pub fn create(device_name: String) -> Result<Self> {
        let conn = serialport::new(device_name.as_str(), 9600)
            .timeout(Duration::from_secs(10))
            .open()
            .with_context(|| format!("Open device {} failed", device_name))?;
        let conn_clone = conn.try_clone().with_context(|| "Serial clone failed")?;
        let reader = BufReader::new(conn_clone);
        let comp = SerialComponents { conn, reader };
        let comp = Mutex::new(comp);
        Ok(Self { comp })
    }

    pub fn send_write_cmd(&self, pin: i32, deg: i32) -> Result<()> {
        let mut comp = self.comp.lock().unwrap();
        let SerialComponents { conn, reader } = &mut *comp;
        let cmd = format!("write {} {}\n", pin, deg);
        conn.write_all(cmd.as_str().as_bytes())
            .with_context(|| "Write cmd failed")?;

        let mut msg = String::new();
        let _ret = reader.read_line(&mut msg)?;
        let msg = msg.trim();
        println!("Get message {}", msg);
        Ok(())
    }
}
