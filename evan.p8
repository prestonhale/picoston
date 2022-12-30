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
        print('you win!', 50,50,10)
        --100 times
        --randomly select lane
        --randomly select animal
    end
end
