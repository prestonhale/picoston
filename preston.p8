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

-- used to help draw lane highlight
lane_y_starts = {20,33,48,65,84}
lane_heights = {12,14,16,18,20}

animal_sprites={64,66,3,66,66}

ui = {
    x=0,
    y=0,
    selected_lane = 1,
    selected_button = 1,
    buttons = {},
    add_button = function(num, ui, x, y)
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
                if self.highlighted!=true then sspr(((animal_sprites[num]% 16)*8),(flr(animal_sprites[num]/16)*8),16,16,self.x+1,self.y+1,8,8) end
                if self.highlighted then
                    rect(
                        self.x-1, 
                        self.y-1, 
                        self.x+button_size+1, 
                        self.y+button_size+1, 
                        PURPLE
                    )
                    sspr(((animal_sprites[num]% 16)*8),(flr(animal_sprites[num]/16)*8),16,16,self.x-3,self.y-3,16,16)    
                end
                if self.can_spawn and ANIMAL_COST[num] > points then
                    rectfill(self.x, 
                    self.y, 
                    self.x+button_size, 
                    self.y+button_size, 
                    5)
                end
            
            end
        }
        add(ui.buttons, button)
    end,
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
            no_spawn = spawn_function(self.selected_lane)
            if no_spawn then
                self.buttons[self.selected_button].can_spawn = no_spawn       
            end
        end
    end,

    draw = function(self)
        -- draw buttons
        for btn in all(self.buttons) do
            btn.draw(btn)
        end
        -- draw lane highlight
        rect(
            0, 
            lane_y_starts[self.selected_lane], 
            20, 
            lane_y_starts[self.selected_lane]+lane_heights[self.selected_lane], 
            7
        )
    end
}

function init_preston(objects)
    for i=0,4 do
        ui.add_button(
            i+1,
            ui,
            first_button_x + i * (button_width + button_buffer), 
            first_button_y
            
        )
    end
    add(objects, ui)
    add(objects, enemy_spawner)
end