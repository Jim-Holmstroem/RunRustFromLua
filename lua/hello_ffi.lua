local ffi = require("ffi")

ffi.cdef[[
    void hello();
    int64_t add(int64_t, int64_t);
    int64_t length(const char *);
    char *duplicate(int64_t, const char *);

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
        const char *msg;
        int32_t count;
    } duplicate_string_t;
    void add_duplicate_strings(
        const duplicate_string_t *,
        const duplicate_string_t *,
        duplicate_string_t *
    );

    typedef struct {
        const char *name; // TODO(gardell): manage dangling pointer
        int64_t created;
        int64_t expire;
    } token_t;

    int32_t new_token(
        const char *,
        token_t *);
]]
local rust = ffi.load("rust")

function duplicate(count, msg)
    local c_str = rust.duplicate(count, msg)
    local str = ffi.string(c_str)
    rust.release(c_str)
    return str
end

local duplicate_string
duplicate_string = ffi.metatype(
    "duplicate_string_t",
    {
        __add = function(a, b)
            local result = duplicate_string()

            rust.add_duplicate_strings(a, b, result)
            ffi.gc(result.msg, rust.release)

            return result
        end,
        __tostring = function(a)
            return string.format(
                "duplicate_string(\"%s\", %d)",
                ffi.string(a.msg),
                a.count
            )
        end,
    }
)

local point
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

local c_token
c_token = ffi.metatype(
    "token_t",
    {
        __tostring = function(a)
            return string.format(
                "token(name: %s, created: %d, expire: %d)",
                ffi.string(a.name), tonumber(a.created), tonumber(a.expire)
            )
        end
    }
)

local new_c_token = function(str_token)
    t = c_token()
    rust.new_token(str_token, t)
    return t
end

local token = {}
token.__index = token

function token.new(str)
    local t = {}
    setmetatable(t, token)
    t.c_token = new_c_token(str)
    return t
end

function token:get_name()
    return ffi.string(self.c_token.name)
end

function token:get_created()
    return tonumber(self.c_token.created) -- TODO(gardell): Use float and no tonumber
end

function token:get_expire()
    return tonumber(self.c_token.expire) -- TODO(gardell): Use float and no tonumber
end

function token:__tostring()
    return string.format(
        "token(name: %s, created: %d, expire: %d)",
        self:get_name(), self:get_created(), self:get_expire()
    )
end

print(token.new("bajs:13:37"))