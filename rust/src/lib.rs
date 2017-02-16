extern crate libc;

use libc::c_char;

use std::ffi::{
    CStr,
    CString,
};

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


//fn to_str(c_str: *const c_char) -> String {
//    unsafe { CStr::from_ptr(c_str) }
//        .to_str()
//        .unwrap()
//
//}
//
//fn to_c_string(string: String) -> *const c_char {
//    CString::new(string)
//        .unwrap()
//        .into_raw()
//}

#[no_mangle]
pub extern fn duplicate(
    count: i64,
    c_msg: *const c_char,
) -> *mut c_char {
    let msg = unsafe { CStr::from_ptr(c_msg) }
        .to_str()
        .unwrap();

    let out = std::iter::repeat(msg)
        .take(count as usize)
        .collect::<String>();

    CString::new(out)
        .unwrap()
        .into_raw()
}

#[no_mangle]
pub extern fn release(msg: *mut c_char) {
    unsafe { CString::from_raw(msg) };
}

#[repr(C)]
pub struct DuplicateString {
    msg: *const c_char,
    count: i32,
}

#[no_mangle]
pub extern fn add_duplicate_strings(
    c_ds1: *const DuplicateString,
    c_ds2: *const DuplicateString,
    c_result: *mut DuplicateString,
) {
    let (ds1, ds2, mut result) = unsafe { (&*c_ds1, &*c_ds2, &mut *c_result) };

    let ds1msg = unsafe { CStr::from_ptr(ds1.msg) }
        .to_str()
        .unwrap();

    let ds2msg = unsafe { CStr::from_ptr(ds2.msg) }
        .to_str()
        .unwrap();

    result.msg = CString::new(ds1msg.to_owned() + ds2msg)
        .unwrap()
        .into_raw();
    result.count = ds1.count + ds2.count;
}

#[repr(C)]
pub struct Point {
    x: i32,
    y: i32,
}

#[no_mangle]
pub extern fn add_points(
    c_p1: *const Point,
    c_p2: *const Point,
    c_result: *mut Point,
) {
    let (p1, p2, mut result) = unsafe { (&*c_p1, &*c_p2, &mut *c_result) };

    result.x = p1.x + p2.x;
    result.y = p1.y + p2.y;
}
