pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include tyler.p8
#include michael.p8
#include preston.p8

objects = {}

speed = 1


SPAWN_FUNCTIONS = {
    add_ostrich_in_lane,
    add_bee_giant_in_lane,
    add_bee_giant_in_lane,
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
end

function _draw()
    for obj in all(objects) do
        obj.type.draw(obj)
    end
end

-- helper functions
function get_lane_y(lane_index)
    return (lane_index-1)*lane_length
end
__gfx__
00000000555555555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000008888880000005444400
00000000533333333333333500000bbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000088888888880005f444400
007007005333333333333335000bbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000088877777788800ff444400
00077000533333333333333500bbbbb3333bbb0000000000000000000000000000000000000000000000000000000000000000000888877777778880ff444400
0007700053333333333333350bbbb3307070bbb00000000000000000000000000000000000000000000000000000000000000000088888777777788000444400
0070070053333333333333350bb3370000007bb00000000000000000000000000000000000000000000000000000000000000000887788877777778800044440
000000005333333333333335bb330000000000b00000000000000000000000000000000000000000000000000000000000000000887778887777778800044440
000000005333333333333335bb300070070000000000000000000000000000000000000000000000000000000000000000000000887777888777778800044440
000000005333333333333335bb370bbbbb00000000b7000000000000000000000000000000000000000000000000000000000000887777788877778800044440
000000005333333333333335bbb0bbbbbbb000bbbbb0b00000000000000000000000000000000000000000000000000000000000887777778887778800044440
000000005333333333333335bbbbbbbb3bbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000887777777888778800044440
000000005333333333333335bbbbbb33bbbbbbbbb707070700000000000000000000000000000000000000000000000000000000088777777788888000004444
000000005333333333333335bbbb3bbbbbbbb777bbbbbbb000000000000000000000000000000000000000000000000000000000088877777778888000004444
000000005333333333333335bbbbbbbbbbbb33000000000000000000000000000000000000000000000000000000000000000000008887777778880000004444
0000000053333333333333350bbbb3330bbbb3300000000000000000000000000000000000000000000000000000000000000000000888888888800000004444
0000000055555555555555550bbbbb000bbbbb000000000000000000000000000000000000000000000000000000000000000000000008888880000000054444
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000550000000005ffff0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055000000000ffff00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555655000000fff000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555566500000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555000000000000
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
00005050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f
00000077777770000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000070000770000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000700007700000066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000700077700000666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000700777000070666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07700777777000770666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00770077770077000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077007707700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000070770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000700077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007700007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00770000000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f
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
