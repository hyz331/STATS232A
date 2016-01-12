N = 4000;

% Sample 1200x1200
close all;
axis([0 100 0 100]);
hold on;
for i = 1:N
	p = mod(rand(1, 2) * 10000, 100);
	theta = mod(rand() * 10000, 2*pi);
	gen_line_obj(p, theta, sample_len(), 0.6);
end
% save
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 13.65 13.65];
fig.PaperPositionMode = 'manual';
print('-dpng', '-r75', 'lines');
exit
% Sample 512x512
close all;
axis([0 100 0 100]);
hold on;
for i = 1:N
	p = mod(rand(1, 2) * 10000, 100);
	theta = mod(rand() * 10000, 2*pi);
	gen_line_obj(p, theta, sample_len()/2, 1);
end
% save
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6.83 6.83];
fig.PaperPositionMode = 'manual';
print('-dpng', '-r75', 'lines_m');

% Sample 256x256
close all;
axis([0 100 0 100]);
hold on;
for i = 1:N
	p = mod(rand(1, 2) * 10000, 100);
	theta = mod(rand() * 10000, 2*pi);
	gen_line_obj(p, theta, sample_len()/4, 1);
end
% save
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 3.41 3.41];
fig.PaperPositionMode = 'manual';
print('-dpng', '-r75', 'lines_s');


% Crop and plot
close all;
m = imread('lines.png');
m_m = imread('lines_m.png');
m_s = imread('lines_s.png');

subplot(3, 2, 1);
offset = 300;
imshow(m(offset:offset+128, offset:offset+128));
title('1024x1024');
subplot(3, 2, 2);
offset = 500;
imshow(m(offset:offset+128, offset:offset+128));
title('1024x1024');

subplot(3, 2, 3);
offset = 100;
imshow(m_m(offset:offset+128, offset:offset+128));
title('512x512');
subplot(3, 2, 4);
offset = 200;
imshow(m_m(offset:offset+128, offset:offset+128));
title('512x512');

subplot(3, 2, 5);
offset = 40;
imshow(m_s(offset:offset+128, offset:offset+128));
title('256x256');
subplot(3, 2, 6);
offset = 80;
imshow(m_s(offset:offset+128, offset:offset+128));
title('256x256');

