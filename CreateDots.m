% This function moves the robot arm to create 0-5 dots of given a coin
% type. Returns the amount of positions M5 turned from the center
function M5position = CreateDots(a, coinType, coinCount)

    %Current dot count
    dotCount = 0;
    M5position = 0;
    
    %Calculated M3 target values from FK, use average of row in upper/lower quadrants
    QDTarget = 0.723;
    NPTarget = 0.503;
    
    %If Quarter or Nickle, turn M5 left, else turn right
    if(coinType == 'Q' | coinType == 'N')
        writeDigitalPin(a,'D38',0);
        writeDigitalPin(a,'D39',1);
    else
        writeDigitalPin(a,'D38',1);
        writeDigitalPin(a,'D39',0);
    end
    
    while(dotCount ~= coinCount)
        
        %Move to next M5position, uses a PWM of 0.3/0.1 sec burst
        M5position = M5position + 1;
        writePWMDutyCycle(a,'D6',0.30);
        pause(0.1);
        writePWMDutyCycle(a,'D6',0.0);
        pause(0.7);
        
        %Determine target M3 based on upper/lower quadrant
        if(coinType == 'Q' | coinType == 'D')
            M3target = QDTarget;
        else
            M3target = NPTarget;
        end
        
        %Move M3 to target value
        if(dotCount == 0)
        if (readVoltage(a,'A1') >= M3target)
            writeDigitalPin(a,'D34',0);
            writeDigitalPin(a,'D35',1);
            writePWMDutyCycle(a,'D4',0.35);
            while(readVoltage(a,'A1') >= M3target)
            end
            writePWMDutyCycle(a,'D4',0.0);
        else
            writeDigitalPin(a,'D34',1);
            writeDigitalPin(a,'D35',0);
            writePWMDutyCycle(a,'D4',0.35);
            while(readVoltage(a,'A1') <= M3target)
            end
            writePWMDutyCycle(a,'D4',0.0);
        end
        end
        pause(1);
        
        %Move M4 down to target M4 value, based on upper/lower quadrant
        writeDigitalPin(a,'D36',0);
        writeDigitalPin(a,'D37',1);
        writePWMDutyCycle(a,'D5',0.35);
        %Calculated average M4 target value from FK
        if(coinType == 'Q' | coinType == 'D')
            while(readVoltage(a,'A2') >= 2.75)
            end
        else
            while(readVoltage(a,'A2') >= 3.00)
            end
        end
        writePWMDutyCycle(a,'D5',0.0);
        pause(1)
        
        %Return M4 to home posistion
        writeDigitalPin(a,'D36',1);
        writeDigitalPin(a,'D37',0);
        writePWMDutyCycle(a,'D5',0.35);
        while(readVoltage(a,'A2') <= 3.20)
        end
        writePWMDutyCycle(a,'D5',0.0);
        
        %Increment dot count
        dotCount = dotCount + 1;
        
    end
end

