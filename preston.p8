ORANGE = 9
PURPLE = 2

-- config
first_button_x = 15
first_button_y = 112
button_width = 8
button_buffer = 14
button_size = 10

ui = {
    selected_button=1,
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
        end,
        draw = function(self)
            -- draw buttons
            for btn in all(self.buttons) do
                btn.draw(btn)
            end
        end
    }
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
end