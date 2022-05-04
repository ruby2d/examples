module Macro
    class Macros
        def initialize(vmr)
            @vmr = vmr
        end

        def button_1(on)
            if on
                @vmr.strip[0].mute = true
                @vmr.strip[3].gain = -3.6
                @vmr.bus[2].eq = true
                @vmr.bus[1].gain = 0.0
            else
                @vmr.strip[0].mute = false
                @vmr.strip[3].gain = 0.0
                @vmr.bus[2].eq = false
                @vmr.bus[1].gain = -3.6
            end
        end

        def button_2(on)
            if on
                @vmr.strip[2].mute = true
                @vmr.strip[1].comp = 3.8
            else
                @vmr.strip[2].mute = false
                @vmr.strip[1].comp = 6.2
            end
        end

        def button_3(on)
            if on
                @vmr.strip[3].mute = true
                @vmr.strip[2].A1 = false
                @vmr.strip[0].limit = -33
            else
                @vmr.strip[3].mute = false
                @vmr.strip[2].A1 = true
                @vmr.strip[0].limit = 0
            end
        end

        def button_4(on)
            if on
                @vmr.strip[3].mute = true
                @vmr.strip[2].B2 = false
            else
                @vmr.strip[3].mute = false
                @vmr.strip[2].B2 = true
            end
        end

        def button_5(on)
            if on
                @vmr.strip[3].mute = true
                @vmr.strip[3].A1 = false
                @vmr.strip[4].A2 = false
            else
                @vmr.strip[3].mute = false
                @vmr.strip[3].A1 = true
                @vmr.strip[4].A2 = true
            end
        end
    end
end
