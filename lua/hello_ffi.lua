local ffi = require("ffi")

ffi.cdef[[
void hello();
int64_t add(int64_t, int64_t);
int64_t length(const char *);
char *duplicate(int64_t, const char *msg);
// stdlib
void free(void *);
]]
local rust = ffi.load("rust")

function duplicate(count, msg)
    local c_str = rust.duplicate(count, msg)
    local str = ffi.string(c_str)
    ffi.C.free(c_str)
    return str
end

rust.hello()
print(rust.add(13, 37))
print(rust.length("slimjim"))
print(duplicate(3, "bork!"))
