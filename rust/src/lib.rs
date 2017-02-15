#[no_mangle]
pub extern fn hello() {
    println!("hello")
}

#[no_mangle]
pub extern fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[no_mangle]
pub extern fn length(str: String) -> i64 {
    str.len() as i64
}
