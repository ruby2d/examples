require 'ruby2d'
require 'voicemeeter'
require_relative 'macros'

include Macro

def make_app(num_buttons)
    @num_buttons = num_buttons
    set title: "Voicemeeter.#{@vmr.kind.name.capitalize} Macros"
    set height: 110
    set width: (@num_buttons * 100) + (@num_buttons * 5)

    # create and position buttons
    @buttons =
        (0.upto(@num_buttons)).map do |i|
            Square.new(x: i * 105, y: 5, size: 100, color: 'blue')
        end

    # initialize button states
    @button_states = Array.new(@num_buttons, false)

    # create and position labels
    @labels =
        (0.upto(@num_buttons)).map do |i|
            Text.new("macro [#{i + 1}]", x: i * 105 + 5, y: 50, color: 'white')
        end

    @macros = Macros.new(@vmr)

    # define what happens on mouse click
    on :mouse_down do |event|
        @buttons.each.with_index do |button, i|
            if button.contains?(event.x, event.y)
                # change button color and toggle state
                if @button_states[i]
                    @button_states[i] = false
                    button.color = 'blue'
                else
                    @button_states[i] = true
                    button.color = 'red'
                end

                # perform any voicemeeter operations
                @macros.send("button_#{i + 1}", @button_states[i])
            end
        end
    end

    on :key_down do |event|
        i = event.key.to_i - 1
        if (0...@num_buttons).include? i
            # change button color and toggle state
            if @button_states[i]
                @button_states[i] = false
                @buttons[i].color = 'blue'
            else
                @button_states[i] = true
                @buttons[i].color = 'red'
            end

            # perform any voicemeeter operations
            @macros.send("button_#{event.key}", @button_states[i])
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    kind_id = 'banana'

    # start Voicemeeter GUI
    Voicemeeter.start(kind_id)

    #log in to voicemeeter
    @vmr = Voicemeeter.remote(kind_id)

    make_app(num_buttons = 5)

    @vmr.run { show }
end
