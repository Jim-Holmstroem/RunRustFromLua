extern crate libc;

use libc::c_char;
use libc::c_void;
use libc::free;
use libc::malloc;
use libc::memcpy;
use std::ffi::CStr;

#[no_mangle]
pub extern fn hello() {
    println!("hello")
}

#[no_mangle]
pub extern fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[no_mangle]
pub extern fn length(str: *const c_char) -> i64 {
    let c_str = unsafe { CStr::from_ptr(str) };
    c_str.to_bytes().len() as i64
}

#[no_mangle]
pub extern fn duplicate(count: i64, msg: *const c_char) -> *mut c_char {
    let len = length(msg);

    unsafe {
        let out = malloc((count * len + 1) as usize);

        for i in 0..count {
            memcpy(out.offset((i * len) as isize), msg as *mut c_void,
                len as usize);
        }
        out as *mut c_char
    }
}

#[no_mangle]
pub extern fn release(msg: *const c_char) {
    unsafe { free(msg as *mut c_void) }
}
