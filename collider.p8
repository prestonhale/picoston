pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

collider = {
}

function collider:new(obj)
    obj = {} or obj
    setmetatable(obj, self)
    self.__index = self
    obj.colliding_with = {}
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
        if k.is_friendly and k.x>obj.x then
            can_move = false
        end
        if not k.is_friendly and not k.is_projectile then 
            can_move = false
            k.health-=obj.dmg
        end
    end
    if win then
        can_move = true
    end
    return can_move
end
