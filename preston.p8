ORANGE = 9
PURPLE = 2

-- config
first_button_x = 12
first_button_y = 105
button_width = 8
button_buffer = 10

ui = {
    buttons = {},
    add_button = function(ui, x, y)
        local button = {
            x=x,
            y=y,
            draw = function(self) 
                rectfill(self.x, self.y, self.x+8, self.y+8, ORANGE)
                rect(self.x, self.y, self.x+8, self.y+8, PURPLE)
            end
        }
        add(ui.buttons, button)
    end,
    type = {
        update = function(self)
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
    for i=0,5 do
        ui.add_button(
            ui,
            first_button_x + i * (button_width + button_buffer), 
            first_button_y
        )
    end
    add(objects, ui)
end