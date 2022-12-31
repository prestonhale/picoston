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
        spr(192, 0, 0, 2, 2)
        print(points, 4, 3)
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
        enemy_spawner.chance_to_spawn = 0
        enemy.dmg = 9999
        -- enemy_spawner.spawn_speed = 1

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
    
            self.collider:update()
            self.show_health = false
        end

        function enemy:jump()
            local y = get_lane_y(self.lane_index)+3
            
            if self.y <= y-15 then
                self.desc = true
                self.flipped = true
            end
            if self.desc == true and self.y != y then
                self.y += 1
            elseif self.desc and self.y == y then
                self.jumped = false
                self.desc = false
                self.flipped = false
            else
                self.y -= 1
            end
        end

        function enemy:draw()
            spr(self.sprite, self.x, self.y, 2, 2, self.flipped)
            self.sprite_timer += 1
            if self.sprite_timer > 10 then
                if self.sprite == self.sprite_1 then
                    self.sprite = self.sprite_2
                elseif self.sprite == self.sprite_2 then
                    self.sprite = self.sprite_1 
                end
                self.sprite_timer = 0
            end

            if frame%60 == 0 then
                self.jumped = true
            end

            if self.jumped == true then
                self:jump()   
            else
                self.y = get_lane_y(self.lane_index)+3
            end
        end  
    end
end