%Based on a webcam image of coins, tally the amount of coins on a piece of
%paper using a quadrant system. OWI Robotic Arm is 21cm from the wall to the
%middle of the arm's base foot. The center of the paper is roughly 20 cm
%off the ground. Assumes that motor M5 is centered and aligned to the wall.

clc; clear;

%Get image from webcam
cam = webcam('Logitech');
cam.Resolution = '1280x960';
img = snapshot(cam);
imshow(img);

%Calculate # of coins from image
coins = coincounter(img);

%Arduino setup
a = arduino();
configurePin(a,'D4','PWM'); %M3 speed
configurePin(a,'D5','PWM'); %M4 speed
configurePin(a,'D6','PWM'); %M5 speed
configurePin(a,'D34','DigitalOutput');  %M3 direction
configurePin(a,'D35','DigitalOutput');
configurePin(a,'D36','DigitalOutput');  %M4 direcction
configurePin(a,'D37','DigitalOutput');
configurePin(a,'D38','DigitalOutput');  %M5 direction
configurePin(a,'D39','DigitalOutput');

%Run algorithms for each coin type, use M5position to return to the center

%Pennies
if(coins(1) > 0)
    M5position = CreateDots(a,'P',coins(1));        
    writeDigitalPin(a,'D38',0);
    writeDigitalPin(a,'D39',1);
    for x = 1:M5position
        writePWMDutyCycle(a,'D6',0.34);
        pause(0.1);
        writePWMDutyCycle(a,'D6',0.0);
        pause(0.7);
    end
end

%Dimes
if(coins(2) > 0)
    M5position = CreateDots(a,'D',coins(2));
    writeDigitalPin(a,'D38',0);
    writeDigitalPin(a,'D39',1);
    for x = 1:M5position
        writePWMDutyCycle(a,'D6',0.34);
        pause(0.1);
        writePWMDutyCycle(a,'D6',0.0);
        pause(0.7);
    end
end

%Nickles
if(coins(3) > 0)
    M5position = CreateDots(a,'N',coins(3));
    writeDigitalPin(a,'D38',1);
    writeDigitalPin(a,'D39',0);
    for x = 1:M5position
        writePWMDutyCycle(a,'D6',0.34);
        pause(0.1);
        writePWMDutyCycle(a,'D6',0.0);
        pause(0.7);
    end
end

%Quarters
if(coins(4) > 0)
    M5position = CreateDots(a,'Q',coins(4));
    writeDigitalPin(a,'D38',1);
    writeDigitalPin(a,'D39',0);
    for x = 1:M5position
        writePWMDutyCycle(a,'D6',0.33);
        pause(0.1);
        writePWMDutyCycle(a,'D6',0.0);
        pause(0.7);
    end
end