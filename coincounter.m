% This function takes an image of some US coins on a sufficiently contrasting
% background and returns an array listing the number of each coin found in
% form [P D N Q]

function [coins] = coincounter(img)
	% radius values for the various coins
	% range 1-2 is dimes & pennies, 2-3 is nickels, 3-4 is quarters
	cr = [32 40 46 52];
	% saturation threshold above which a correctly sized coin is considered a penny
	penny_sat_threshold = .55;
	img_h = rgb2hsv(img); % HSV format used for color discrimination between pennies and dimes
	[centers, radii] = imfindcircles(img, [cr(1) cr(4)], 'Sensitivity', .85);
	coins = zeros(1,4);
	for i = 1:length(radii)
		if radii(i) < cr(2) % dime or penny; we discriminate between the two based on color since they are close in size
			% specifically, we compare the saturation value against a fixed
			% threshold (brown has a greater saturation than gray)
			if img_h(round(centers(i,2)), round(centers(i,1)), 2) > penny_sat_threshold % penny
				coins(1) = coins(1) + 1;
			else % dime
				coins(2) = coins(2) + 1;
			end
		elseif radii(i) < cr(3) % nickel
			coins (3) = coins(3) + 1;
		else % quarter
			coins(4) = coins(4) + 1;
		end
	end
end