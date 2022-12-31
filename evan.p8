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


gates_destroyed = 0
function check_win()
    if gates_destroyed >= 5 then
        win = true
    end
    if win == true then
        rectfill(47,47,82,57,3) 
        print('you win!', 50,50,10)
        points=99

        enemy_spawner.chance_to_spawn = 0
        bee_giant.chance_to_spawn = 0.8
        ostrich.chance_to_spawn = 0.6
        elephant.chance_to_spawn = 0.2
        monkey.chance_to_spawn = 0.5
        blue_whale.chance_to_spawn = 0.02

        if frame%5==0 then  
            for animal in all(ANIMALS) do
                if rnd(1)+.0001 <= animal.chance_to_spawn then
                    local lane = flr(rnd(5))+1
                    add_in_lane(animal, lane)
                end
            end    
        end
    end
end

function check_lose()
    if game_over==true and win==false then
        rectfill(39,47,84,57,0) 
        print('game over!',43,50,8)

        function enemy:update()
            local can_move = true
            for k,v in pairs(self.collider.colliding_with) do
                self.do_damage(self, k)
                if k.is_friendly then 
                    can_move = false
                end
                if not k.is_friendly and k.x<self.x and not k.is_gate then
                    can_move = false
                end
            end
        
            if can_move then
                self.x -= 0.5
            end
        
            self.y = get_lane_y(self.lane_index)+3
            self.sprite_timer += 1
            -- if self.sprite_timer > 10 then
            --     if self.sprite == self.sprite_1 then
            --         self.sprite = self.sprite_2
            --     elseif self.sprite == self.sprite_2 then
            --         self.sprite = self.sprite_1 
            --     end
            --     self.sprite_timer = 0
            -- end
        
            self.collider:update()
            
            if self.health <=0 then
                del(objects, self)
            end

            function enemy:draw()
                -- if self.health<100 then
                --     rect(self.x+4,self.y-5,self.x+15,self.y-3,7)
                --     length = convert(self.health,0,self.max_health,0,9)
                --     if length < 0 then
                --         length=0
                --     end
                --     line(self.x+5,self.y-4,self.x+14,self.y-4,6)
                --     line(self.x+5,self.y-4,self.x+5+length,self.y-4,8)
                -- end
                if flipped then
                    spr(self.sprite, self.x,self.y, 2, 2)
                    flipped = false
                else
                    spr(self.sprite, self.x, self.y, 2, 2, true)
                    flipped = true
                end
            end
        
            remove_if_out_of_bounds(self)
        end
    end
end