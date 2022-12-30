pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

ORANGE = 9
PURPLE = 2
DARK_GREY = 5

-- config
first_button_x = 15
first_button_y = 112
button_width = 8
button_buffer = 14
button_size = 10
button_grow = 3

-- Lane is indexed starting at 1
function lane_y_starts(lane_index)
    return lane_offset + ((lane_index-1) * lane_height)
end
-- lane_y_starts = {20,37,54,71,88}

animal_sprites={64,66,3,98,71}

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
            animal_type = ANIMALS[num],
            draw = function(self)
                local button_size = button_size
                local button_offset = 0
                local animal_size = 8
                local rect_color = ORANGE
                local sprite_offset = {x=2, y=1}
                if self.highlighted then
                    sprite_offset = {x=0, y=0}
                    button_size = button_size + button_grow
                    button_offset = button_grow
                    animal_size = 16
                    rect(
                        self.x-1-button_offset, 
                        self.y-1-button_offset, 
                        self.x+1+button_size, 
                        self.y+1+button_size, 
                        PURPLE
                    )
                end                   
                if self.animal_type.cost > points then
                    rect_color = DARK_GREY
                end
                rectfill(
                    self.x-button_offset, 
                    self.y-button_offset, 
                    self.x+button_size, 
                    self.y+button_size, 
                    rect_color
                )
                sspr(
                    ((animal_sprites[num] % 16)*8),
                    (flr(animal_sprites[num] / 16)*8),
                    16,16,
                    self.x-button_offset+sprite_offset.x,self.y-button_offset+sprite_offset.y,
                    animal_size,animal_size
                )   
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

            -- don't spawn animal if something is already in the spawning space
            open_space = true
            for obj in all(objects) do
                if obj.lane_index != nil and obj.lane_index == self.selected_lane and obj.x < 12 then
                    -- bees and blue whales will ignore this check
                    if animal_sprites[self.selected_button] != 71 and animal_sprites[self.selected_button] != 66 then
                        open_space = false
                    end
                end
            end
            if open_space then
                no_spawn = add_in_lane(ANIMALS[self.selected_button], self.selected_lane)
            end

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
            lane_y_starts(self.selected_lane), 
            20, 
            lane_y_starts(self.selected_lane)+16, 
            7
        )
    end
}

-------------
--- Gates ---
-------------
gate = {
    full_health_spr = 134,
    destroyed_spr = 135,
    health = 100,
    is_friendly = false,
    is_gate = true,
    x=120
}

function gate:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function gate:update()
    if self.health <= 0 then self.collider = nil end
    if self.collider then self.collider:update() end
end

function gate:draw()
    local sprite = self.full_health_spr
    if self.health <= 0 then sprite=self.destroyed_spr end
    local sx, sy = get_sprite_coords(sprite)
    sspr(
        sx, sy,
        8, 16, 
        self.x, self.y,
        8, lane_height
    )
    -- TODO: Health bar
end


function init_preston(objects)
    for i=0,4 do
        ui.add_button(
            i+1,
            ui,
            first_button_x + i * (button_width + button_buffer), 
            first_button_y
            
        )
    end
    for i=0,4 do
        local gate = gate:new()
        gate.y = lane_y_starts(i+1)
        gate.collider = collider:new()
        gate.lane_index = i+1
        add(objects, gate)
    end
    add(objects, ui)
    add(objects, enemy_spawner)
end