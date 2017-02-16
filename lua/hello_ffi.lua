local ffi = require("ffi")

ffi.cdef[[
    void hello();
    int64_t add(int64_t, int64_t);
    int64_t length(const char *);
    char *duplicate(int64_t, const char *msg);
    void release(char *);

    typedef struct {
        int32_t x, y;
    } point_t;
    void add_points(
        const point_t *,
        const point_t *,
        point_t *
    );

    typedef struct {
        const char * msg;
        int32_t count;
    } duplicate_string_t;
    void add_duplicate_strings(
        const duplicate_string_t *,
        const duplicate_string_t *,
        duplicate_string_t *
    );

]]
local rust = ffi.load("rust")

function duplicate(count, msg)
    local c_str = rust.duplicate(count, msg)
    local str = ffi.string(c_str)
    rust.release(c_str)
    return str
end

duplicate_string = ffi.metatype(
    "duplicate_string_t",
    {
        __add = function(a, b)
            local result = duplicate_string()

            rust.add_duplicate_strings(a, b, result)

            return result
        end,
        __tostring = function(a)
            return string.format(
                "duplicate_string(%s, %d)",
                a.msg,
                a.count
            )
        end,
    }
)

point = ffi.metatype(
    "point_t",
    {
        __add = function(a, b)
            local result = point()
            rust.add_points(a, b, result)

            return result
        end,
        __tostring = function(a)
            return string.format(
                "point(%i, %i)",
                a.x,
                a.y
            )
        end,
    }
)

rust.hello()
print(rust.add(13, 37))
print(rust.length("slimjim"))
print(duplicate(3, "bork!"))

local p = point(1, 2) + point(3, 4)

print(p)

local ds = duplicate_string("Tipi Tais ", 3) + duplicate_string("Lee ba Time ", 2)

print(ds)
