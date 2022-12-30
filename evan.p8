pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

scoreboard = {    
    counter=0,
    update = function(self)
        if flr(time()) > self.counter then
            self.counter+=1
            points+=1
        end
    end,
    draw = function(self)
        spr(192, 0, 105, 2, 2)
        print(points, 4, 108)
    end
}

function init_evan(objects)
    points = 1
    add(objects, scoreboard)
end


function check_win()
    if win == true then
        rectfill(47,47,82,57,3) 
        print('you win!', 50,50,10)
        enemy_spawner.chance_to_spawn = 0
        points=99
        bee_giant.chance_to_spawn = 0.8
        ostrich.chance_to_spawn = 0.6
        elephant.chance_to_spawn = 0.2
        monkey.chance_to_spawn = 0.5
        blue_whale.chance_to_spawn = 0.02
        if frame%5==0 then  
            for animal in all(ANIMALS) do
                if rnd(1)+.01 <= animal.chance_to_spawn then
                    local lane = flr(rnd(5))+1
                    add_in_lane(animal, lane)
                end
            end    
       
            
            -- local animal = ANIMALS[flr(rnd(4))+1]
            -- local lane = flr(rnd(5))+1
            -- add_in_lane(animal, lane)
        end
    end
end
