pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
#include tyler.p8
#include michael.p8
#include preston.p8

objects = {}

speed = 1

animal = {
    x = 0,
    y = 0,
    lane_x = 0,
    lane_y = 0,
    draw = function()
    end,
    update = function()
    end
}

function _init()
    init_preston(objects)
end

function _update()
    for obj in all(objects) do
        obj.type.update(obj)
    end
end

function _draw()
    for obj in all(objects) do
        obj.type.draw(obj)
    end
end
