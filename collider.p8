pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

collider = {
    colliding_with = {}
}

function collider:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function collider:collide(other)
    self.colliding_with[other] = 1
end

function collider:update()
    self.colliding_with = {}
end