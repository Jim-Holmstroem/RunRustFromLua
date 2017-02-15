local ffi = require("ffi")

ffi.cdef[[
void hello();
int64_t add(int64_t, int64_t);
int64_t length(const char *);
]]
local rust = ffi.load("rust")

rust.hello()
print(rust.add(13, 37))
print(rust.length("slimjim"))
