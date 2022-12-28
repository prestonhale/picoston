pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

ORANGE = 9
PURPLE = 2

-- Number of functions must be equal to the number of buttons
-- IMPORTANT: Functions must take ONLY the arguments (x,y)
BUTTON_SPAWN_FUNCTIONS = {
    spawn_ostrich_at,
    spawn_ostrich_at,
    spawn_ostrich_at,
    spawn_ostrich_at,
    spawn_ostrich_at,
}

-- config
first_button_x = 15
first_button_y = 112
button_width = 8
button_buffer = 14
button_size = 10

lane_length = 21

ui = {
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
                local spawn_function = SPAWN_FUNCTIONS[1]
                spawn_function(2, get_lane_y(self.selected_lane)+3)
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

function get_lane_y(lane_index)
    return (lane_index-1)*lane_length
end

function init_preston(objects)
    for i=0,4 do
        ui.add_button(
            ui,
            first_button_x + i * (button_width + button_buffer), 
            first_button_y
        )
    end
    add(objects, ui)
end