pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include animal.p8
#include tyler.p8
#include michael.p8
#include preston.p8
#include evan.p8


#include collider.p8

-- animals
#include ostrich.p8
#include bee.p8
#include elephant.p8

-- enemies
#include enemy.p8

objects = {}

win = false
frame = 0

speed = 1

lane_offset = 20 -- height of the "sky" portion of map
lane_height = 17

ANIMALS = {
    ostrich,
    bee_giant,
    elephant,
    monkey,
    blue_whale
}

LANE_Y_VALUES = {
    15,
    32,
    49,
    66,
    83
}

function _init()
    init_michael(objects)
    init_preston(objects)
    init_evan(objects)
end

function _update()
    frame+=1
    check_collisions()

    for obj in all(objects) do
        obj:update()
    end

    debug = stat(1)
end

function _draw()
    local foreground = {}
    for obj in all(objects) do
        -- don't render yet if obj is tagged "foreground"
        if obj.foreground then 
            add(foreground, obj) 
            return
        end
        obj:draw()
    end
    -- draw foreground objects
    for obj in all(foreground) do
        obj:draw()
    end
    print(debug)
    check_win()
end

function check_collisions()
    for i=1,#objects do
        for j=i+1,#objects do
            obj=objects[i]
            other=objects[j]
            --if a table isn't given a specific pixel width, give it a default
            if (other.pwidth==nil) then
                other.pwidth=16
            end
            if (obj.pwidth==nil) then
                obj.pwidth=16
            end
            if  obj.collider
                and other.collider
                and obj.lane_index == other.lane_index
                and obj.x < other.x + other.pwidth 
                and obj.x + obj.pwidth > other.x
                and obj.y < other.y + other.pwidth
                and obj.y + obj.pwidth > other.y
            then
                obj.collider:collide(other)
                other.collider:collide(obj)
            end
        end
    end
end

------------------------
--- utility functions ---
------------------------

function get_sprite_coords(spr_num)
    return (spr_num % 16) * 8, flr(spr_num \ 16) * 8
end 

function get_lane_y(lane_index)
    return LANE_Y_VALUES[lane_index]
end

-- temporary to reduce memory leakage
function remove_if_out_of_bounds(obj)
    if abs(64-obj.x)>80 or abs(64-obj.y)>80 then
        del(objects,obj)
    end
end

-- converts a value from one range of numbers to another
function convert_range(val,s1,e1,s2,e2)
	temp=(val-s1)/(e1-s1)
	return temp*(e2-s2)+s2
end

__gfx__
00000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000dd6600000eae0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000000000000000000000000dd666660000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000000000000000000000d6666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000000000000000000006d6666766000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000000000000000000000666d6666166000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000006666d6666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000066666dd6666d6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000006066666dd6d6d6600c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000666666ddd67760cac0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000066666666666d770c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000066666666660d600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000066666666d00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000066dd0066d00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000066dd0066d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000006600000dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000dd66000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000dd666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000d6666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000006d6666766000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000666d6666166000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000006666d6666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000066666dd6666d6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000006066666dd6d6d6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000666666ddd677600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000066666666666d770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000066666666660d600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000066666666d00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000066dd0066d00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000066dd0066d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000dd0066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000005550000000000000555000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000066660000666650000000000555005000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000088880000000677776006777760000000000005005000044000000000011111111100000000000000000000000000000000000000000000000000000000
0000088858800000677777766777777600666600006666500044a40000000001c66cccc100000000000000000000000000000000000000000000000000000000
0000088855800000677777766777777606777760067777600444444000111101c66c75c100000000000000000000000000000000000000000000000000000000
00000888888000006777777667777776677777766777777644a4444401ccc101cccc75c100000000000000000000000000000000000000000000000000000000
0008888888aaa000a6777765a677776a6777777667777776000000001ccc1101cccc75c100000000000000000000000000000000000000000000000000000000
0088888888aaa000a56666a5aa6666556777777667777776000000001cc11001ccccccc100000000000000000000000000000000000000000000000000000000
0885888800000000a5aa5aa5aaa5aa55a6777765a677776500000000cc110001ccccccc100000000000000000000000000000000000000000000000000000000
8885888880000000a5aa5aa5aaa5aaaaa56666a5aa6666aa00000000c1c11111ccccccc100000000000000000000000000000000000000000000000000000000
8585888880000000a5aa5aa5aaa5aaaaa5aa5aa5aaa5aaaa00000000c1ccccccccccc55100000000000000000000000000000000000000000000000000000000
888888fff000000005aa5aa5aaa5aaa005aa5aa5aaa5aaa000000000111cccccc777777100000000000000000000000000000000000000000000000000000000
08888fff000000000050500000505000005050000050500000000000011111111111111100000000000000000000000000000000000000000000000000000000
00858f50000000000555500005555000055550000555500000000000000111111111111100000000000000000000000000000000000000000000000000000000
00050050000000000050000000500000005000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050050000000005550000555500000555000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000111111111111111111000000000000000000000000000000000000000000
000000000000000000000000444440000000000044444000000000011000000000111ccccccccc66ccccc1110000000000000000000000000000000000000000
00000088880000000444000449999000044400044999900000000011c1000000001ccccccccccc66ccccccc10000000000000000000000000000000000000000
0000088858800000040000449959590004000044995959000000011cc1000000011cccccccccccccccc75cc10000000000000000000000000000000000000000
000008885580000004000994999999000400099499999900000011cc1100000001ccccccccccccccccc75cc10000000000000000000000000000000000000000
00000888888000000400099499999990040009949999999000111ccc1000000001ccccccccccccccccc75cc10000000000000000000000000000000000000000
0008888888aaa00004000044499999900400004449999990011ccccc1000000001ccccccccccccccccccccc10000000000000000000000000000000000000000
0088888888aaa0000400044444444400040004444444440011cccccc1100000011ccccccccccccccccccccc10000000000000000000000000000000000000000
0885888800000000040004444444444004000444444444401cccc1ccc1111111cccccccccccccccccccc5cc10000000000000000000000000000000000000000
8885888880000000040044444444944004004444444494401cc111ccc1cccccccccccccccccccccccccc55510000000000000000000000000000000000000000
858588888000000004004444449994400400444444999440111111ccccccccccccccccccccccccccccccccc10000000000000000000000000000000000000000
888888fff0000000040444494499904404044449449990441110011ccccccccccccccccc11ccc1ccccccc7710000000000000000000000000000000000000000
08888fff000000000444449944990044044444994499004400000011ccccccccccccccc11ccc1177777777710000000000000000000000000000000000000000
00858f500000000000004400449000440000440004440044000000011111111177777771cccc1777777777110000000000000000000000000000000000000000
000500550000000000004400440000440000440000440044000000000000000011111111cc111111111111100000000000000000000000000000000000000000
0050000500000000000044094490094400004400099409440000000000000000000000011110000000000000000000000000000000000000000000000000000f
000004440000000000000000000000003bbbbb3bbbb33bb3b5555445000000000000000000000000000000000000000000000000000000000000000000000000
00004444400044400000044400004440b3b33bb3bb36f33635555544000000000000000000000000000000000000000000000000000000000000000000000000
00000ff50004444400004444400444443f3ff33f336fff6f35555555000000000000000000000000000000000000000000000000000000000000000000000000
000066660000ff5000000ff50000ff50fffffffffffffff6ff5f5fff000000000000000000000000000000000000000000000000000000000000000000000000
00060666000066600000066600006660fff6ff6fffffffffff55fff6000000000000000000000000000000000000000000000000000000000000000000000000
00044466000006600000666604446660fffffffff6ffffffff5f5fff000000000000000000000000000000000000000000000000000000000000000000000000
00444441044406600004446644444660ffffffffffffffffff55ff6f000000000000000000000000000000000000000000000000000000000000000000000000
000ff50144444010004444410ff51010fff66fffffffffff6f5f5fff000000000000000000000000000000000000000000000000000000000000000000000000
006666010ff51010000ff50166661010ffffffffffffffffff55f6ff000000000000000000000000000000000000000000000000000000000000000000000000
06066600666640400066660606664040fffff6fffff6fffff65f5fff000000000000000000000000000000000000000000000000000000000000000000000000
00066606066640400606664406664040ffffffffffff6fffff55fff6000000000000000000000000000000000000000000000000000000000000000000000000
00011100066600000006660001010000fffffffff66fff66ff5f5fff000000000000000000000000000000000000000000000000000000000000000000000000
00010100010100000001010001010000ff66ffff636ff6333f555fff000000000000000000000000000000000000000000000000000000000000000000000000
0004040001010000000101000404000033ffff663b33633bb5555555000000000000000000000000000000000000000000000000000000000000000000000000
00440400040400000004040044040000bb33f3b3bbbb33b3b5555544000000000000000000000000000000000000000000000000000000000000000000000000
00000000440400000044040000000000bbbb3bbbbb3bbbbb35555444000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000b3b3b3bbb3bb3bb300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000004440000000000000000000000444454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000045454000000000000000000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000444440000000000000000000005f5ff6ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000044499900000000000000000000f5ffff6f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000444444400000000000000000000005f5fffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444444000000000000000000000000f5ffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
044454444000000000000000000000005f5f6fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0454544440000000000000000000000065fff6ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
044554fff000000000000000000000005f5fffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444fff000000000000000000000000f5ffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00054f500000000000000000000000005f5fff6f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005005000000000000000000000000f5ff66ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005005000000000000000000000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000445444450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000454454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49494949494949400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444444444444900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444444444444900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444444444444900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444444444444900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444444444444900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49494949494949400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f
__map__
a2a2a2a2a2a2a2a2a2a201010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a2a2a2a2a2a2a2a2a2a201010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
84858485848584858485a2a20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94959495949594959495a2a2a200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8485848584858485848500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9495949594959495949500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8485848584858485848500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9495949594959495949500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8485848584858485848500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9495949594959495949500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
