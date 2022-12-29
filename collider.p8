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

function collider:can_move(obj)
    local can_move = true
    for k,v in pairs(self.colliding_with) do
        if not k.is_friendly then 
            can_move = false
        end
        if k.is_friendly and k.x>obj.x then
            can_move = false
        end
    end
    return can_move
end