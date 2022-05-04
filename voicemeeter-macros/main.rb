require 'ruby2d'
require 'voicemeeter'
require_relative 'macros'

include Macro

def make_app(num_buttons)
    set title: "Voicemeeter.#{@vmr.kind.name.capitalize} Macros"
    set height: 110
    set width: (num_buttons * 100) + (num_buttons * 5)

    # create and position buttons
    @buttons =
        (0.upto(num_buttons)).map do |i|
            Square.new(x: i * 105, y: 5, size: 100, color: 'blue')
        end

    # initialize button states
    @button_states = Array.new(num_buttons, true)

    # create and position labels
    @labels =
        (0.upto(num_buttons)).map do |i|
            Text.new("macro [#{i + 1}]", x: i * 105 + 5, y: 50, color: 'white')
        end

    @macros = Macros.new(@vmr)

    # define what happens on mouse click
    on :mouse_down do |event|
        @buttons.each.with_index do |button, i|
            if button.contains?(event.x, event.y)
                # perform any voicemeeter operations, pass button state
                @macros.send("button_#{i + 1}", @button_states[i])

                # change button color and toggle state
                if @button_states[i]
                    @button_states[i] = false
                    button.color = 'red'
                else
                    @button_states[i] = true
                    button.color = 'blue'
                end
            end
        end
    end

    on :key_down do |event|
        i = event.key.to_i - 1
        @macros.send("button_#{event.key.to_i}", @button_states[i])

        # change button color and toggle state
        if @button_states[i]
            @button_states[i] = false
            @buttons[i].color = 'red'
        else
            @button_states[i] = true
            @buttons[i].color = 'blue'
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
