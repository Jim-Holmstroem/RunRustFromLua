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


fn to_str<'a>(c_str: *const c_char) -> &'a str {
    unsafe { CStr::from_ptr(c_str) }
        .to_str()
        .unwrap()

}

fn to_c_string(string: String) -> *mut c_char {
    CString::new(string)
        .unwrap()
        .into_raw()
}

#[no_mangle]
pub extern fn duplicate(
    count: i64,
    c_msg: *const c_char,
) -> *mut c_char {
    let msg = to_str(c_msg);

    let out = std::iter::repeat(msg)
        .take(count as usize)
        .collect::<String>();

    to_c_string(out)
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
    let (ds1, ds2, mut result) = unsafe { (
        &*c_ds1,
        &*c_ds2,
        &mut *c_result
    ) };

    let (ds1msg, ds2msg) = (to_str(ds1.msg), to_str(ds2.msg));

    result.msg = to_c_string([ds1msg, ds2msg].join("|"));
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


mod tokens {

    struct Token {
        name: String,
        created: i64,
        expire: i64
    }

    impl Token {
        fn new(string: String) -> Option<Token> {
            // TODO(gardell): Return Result with appropriate error code

            let parse = |p| { p.parse().ok() };
            let mut pieces = string.split(':');

            match (
                pieces.next(),
                pieces.next().and_then(parse),
                pieces.next().and_then(parse)
            ) {
                (Some(name), Some(created), Some(expire))
                => Some(Token{
                    name: name.to_owned(),
                    created: created,
                    expire: expire
                }),
                _ => None
            }
        }
    }
}