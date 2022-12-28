pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

ORANGE = 9
PURPLE = 2

-- config
first_button_x = 15
first_button_y = 112
button_width = 8
button_buffer = 14
button_size = 10

lane_length = 21

ui = {
    x=0,
    y=0,
    selected_lane = 1,
    selected_button = 1,
    buttons = {},
    add_button = function(ui, x, y)
        local button = {
            x=x,
            y=y,
            highlighted = false,
            draw = function(self) 
                rectfill(
                    self.x, 
                    self.y, 
                    self.x+button_size, 
                    self.y+button_size, 
                    ORANGE
                )
                if self.highlighted then
                    rect(
                        self.x, 
                        self.y, 
                        self.x+button_size, 
                        self.y+button_size, 
                        PURPLE
                    )
                end
            end
        }
        add(ui.buttons, button)
    end,
    type = {
        update = function(self)
            self.old_button = self.selected_button

            -- Select animal button
            if btnp(0) then
                self.selected_button -= 1
            elseif btnp(1) then
                self.selected_button += 1
            end

            if self.selected_button < 1 then
                self.selected_button = #self.buttons
            end
            if self.selected_button > #self.buttons then
                self.selected_button = 1
            end
            self.buttons[self.old_button].highlighted = false
            self.buttons[self.selected_button].highlighted = true

            -- Select lane
            if btnp(2) then
                self.selected_lane -= 1
            elseif btnp(3) then
                self.selected_lane += 1
            end

            if self.selected_lane < 1 then
                self.selected_lane = 5
            end
            if self.selected_lane > 5 then
                self.selected_lane = 1
            end

            if btnp(4) then
                local spawn_function = SPAWN_FUNCTIONS[self.selected_button]
                spawn_function(self.selected_lane)
            end
        end,

        draw = function(self)
            -- draw buttons
            for btn in all(self.buttons) do
                btn.draw(btn)
            end
            -- draw lane highlight
            line(
                2, 
                get_lane_y(self.selected_lane), 
                2, 
                get_lane_y(self.selected_lane)+lane_length, 
                10
            )
        end
    }
}

enemy_type = {
    sprite_1 = 128,
    sprite_2 = 130,

    collide = function(self)
        for i=1,#objects do
            other = objects[i]
            if other != self 
                and other.type.collideable
                and self.x < other.x + 16 
                and self.x + 16 > other.x
                and self.y < other.y + 16
                and self.y + 16 > other.y
            then
                -- del(objects, self)
                self.colliding = true
                other.type.collide(other, self)
                return
            end
        end
    end,

    update = function(self)
        if not self.colliding then
            self.x -= 1
        end
        self.y = get_lane_y(self.lane_index)+3
        self.sprite_timer += 1
        if self.sprite_timer > 10 then
            if self.sprite == self.type.sprite_1 then
                self.sprite = self.type.sprite_2
            elseif self.sprite == self.type.sprite_2 then
                self.sprite = self.type.sprite_1 
            end
            self.sprite_timer = 0
        end
        self.type.collide(self)
    end,

    draw = function(self)
        spr(self.sprite, self.x, get_lane_y(self.lane_index)+3, 2, 2)
    end
}

enemy_spawner = {
    -- config
    chance_to_spawn = 0.03,
    enemy_sprite = 128,

    -- state
    time_since_spawn = 0,
    type = {
        update = function(self)
            self.time_since_spawn +=1

            -- if self.time_since_spawn < 8 then -- don't spawn too fast
            --     return
            -- end 

            if rnd(1) < self.chance_to_spawn then
                self.spawn_enemy(self)
                time_since_spawn = 0
            end
        end,
        draw = function(self)
        end
    },
    spawn_enemy = function(self)
        lane_index = flr(rnd(6))
        enemy = {
            sprite = enemy_type.sprite_1,
            colliding = false,
            x=100,
            y=0,
            sprite_timer=0,
            lane_index=lane_index,
            type=enemy_type
        }
        add(objects, enemy)
    end, 
}

function init_preston(objects)
    for i=0,4 do
        ui.add_button(
            ui,
            first_button_x + i * (button_width + button_buffer), 
            first_button_y
        )
    end
    add(objects, ui)
    add(objects, enemy_spawner)
end