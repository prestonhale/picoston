pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include tyler.p8
#include michael.p8
#include preston.p8

-- animals
#include ostrich.p8
#include bee.p8

-- enemies
#include enemy.p8

objects = {}

speed = 1

debug = "no debug"

SPAWN_FUNCTIONS = {
    add_ostrich_in_lane,
    add_bee_giant_in_lane,
    add_elephant_in_lane,
    add_bee_giant_in_lane,
    add_bee_giant_in_lane
}

function _init()
    init_michael(objects)
    init_preston(objects)
    init_tyler(objects)
end

function _update()
    
    for obj in all(objects) do
        obj.type.update(obj)
    end

    check_collisions()
      
end

function _draw()
    for obj in all(objects) do
        obj.type.draw(obj)
    end
    print(debug)
end

function check_collisions()
    for i=1,#objects do
        for j=i+1,#objects do
            obj=objects[i]
            other=objects[j]
            if  obj.type.is_collideable
                and other.type.is_collideable
                and obj.lane_index == other.lane_index
                and obj.x < other.x + 16 
                and obj.x + 16 > other.x
                and obj.y < other.y + 16
                and obj.y + 16 > other.y
            then
                obj.type.collide(obj, other)
                other.type.collide(other, obj)
            end
        end
    end
end

--- helper functions ---

function get_lane_y(lane_index)
    return (lane_index-1)*lane_length
end

-- temporary to reduce memory leakage
function remove_if_out_of_bounds(obj)
    if abs(64-obj.x)>80 or abs(64-obj.y)>80 then
        del(objects,obj)
    end
end
__gfx__
00000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000008888880000005444400
0000000000000000000000000000000dd6600000eae000000000000000000000000000000000000000000000000000000000000000088888888880005f444400
007007000000000000000000000000dd666660000e000000000000000000000000000000000000000000000000000000000000000088866666688800ff444400
000770000000000000000000000000d66666600000000000000000000000000000000000000000000000000000000000000000000888877777768880ff444400
000770000000000000000000000006d6666766000000000000000000000000000000000000000000000000000000000000000000088888777777688000444400
007007000000000000000000000666d6666166000000000000000000000000000000000000000000000000000000000000000000886688877777768800044440
000000000000000000000000006666d6666666000000000000000000000000000000000000000000000000000000000000000000887768887777768800044440
000000000000000000000000066666dd6666d6600000000000000000000000000000000000000000000000000000000000000000887776888777768800044440
0000000000000000000000006066666dd6d6d6600c00000000000000000000000000000000000000000000000000000000000000887777688877768800044440
00000000000000000000000000666666ddd67760cac0000000000000000000000000000000000000000000000000000000000000887777768887768800044440
0000000000000000000000000066666666666d770c00000000000000000000000000000000000000000000000000000000000000887777776888768800044440
0000000000000000000000000066666666660d600000000000000000000000000000000000000000000000000000000000000000088777777688888000004444
00000000000000000000000000066666666d00600000000000000000000000000000000000000000000000000000000000000000088877777768888000004444
00000000000000000000000000066dd0066d00600000000000000000000000000000000000000000000000000000000000000000008887777768880000004444
00000000000000000000000000066dd0066d00000000000000000000000000000000000000000000000000000000000000000000000888888888800000004444
0000000000000000000000000006600000dd00000000000000000000000000000000000000000000000000000000000000000000000008888880000000054444
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000000005ffff0
0000000000000000000000000000000dd66000000000000000000000000000000000000000000000000000000000000000000000000000055000000000ffff00
000000000000000000000000000000dd666660000000000000000000000000000000000000000000000000000000000000000000000055555655000000fff000
000000000000000000000000000000d6666660000000000000000000000000000000000000000000000000000000000000000000000555555566500000000000
000000000000000000000000000006d6666766000000000000000000000000000000000000000000000000000000000000000000000055555555000000000000
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
00000000000000000000000000000dd006600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f
00000000000000000000000000005550000000000000555000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000066660000666650000000000555005000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000677776006777760000000000005005000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000004440000006777777667777776006666000066665000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000045454000006777777667777776067777600677776000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000044444000006777777667777776677777766777777600000000000000000000000000000000000000000000000000000000000000000000000000000000
0000004449990000a6777765a677776a677777766777777600000000000000000000000000000000000000000000000000000000000000000000000000000000
0004444444000000a56666a5aa666655677777766777777600000000000000000000000000000000000000000000000000000000000000000000000000000000
0044444400000000a5aa5aa5aaa5aa55a6777765a677776500000000000000000000000000000000000000000000000000000000000000000000000000000000
0444544440000000a5aa5aa5aaa5aaaaa56666a5aa6666aa00000000000000000000000000000000000000000000000000000000000000000000000000000000
0454544440000000a5aa5aa5aaa5aaaaa5aa5aa5aaa5aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000
044554fff000000005aa5aa5aaa5aaa005aa5aa5aaa5aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444fff000000000050500000505000005050000050500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00054f50000000000555500005555000055550000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050005000000000050000000500000005000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050005000000005550000555500000555000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000045454000000000000044400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000044444000000000000454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000044499900000000000444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00044444440000000004444444999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444444000000000044444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04445444400000000444544440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04545444400000000454544440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
044554fff0000000044554fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444fff0000000000444fff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00054f500000000000054f5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005050000000000000505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000505000000000000050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f
00000444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00004444400044400000044400004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000ff5000444440000444440044444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000066660000ff5000000ff50000ff50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060666000066600000066600006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00044466000006600000666604446660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444441044406600004446644444660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ff50144444010004444410ff51010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
006666010ff51010000ff50166661010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06066600666640400066660606664040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066606066640400606664406664040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011100066600000006660001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010100010100000001010001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040400010100000001010004040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00440400040400000004040044040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440400000044040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000045454000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000044444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000044499900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00044444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04445444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04545444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
044554fff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00054f50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
