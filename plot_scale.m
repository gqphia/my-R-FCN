load('combine_scale_equals_32_ratio=0.5.mat');
figure(1);
plot(ap_for_bins);
grid;
hold on;

load('combine_scale_equals_64_ratio=0.5.mat');
plot(ap_for_bins);
hold on;

load('combine_scale_equals_128_ratio=0.5.mat');
plot(ap_for_bins);
hold on;

load('combine_scale_equals_256_ratio=0.5.mat');
plot(ap_for_bins);
hold on;

load('combine_scale_equals_512_ratio=0.5.mat');
plot(ap_for_bins);
hold on;



load('scale_equals_32_ratio=0.5.mat');
plot(ap_for_bins,'--');
grid;
hold on;

load('scale_equals_64_ratio=0.5.mat');
plot(ap_for_bins,'--');
hold on;

load('scale_equals_128_ratio=0.5.mat');
plot(ap_for_bins,'--');
hold on;

load('scale_equals_256_ratio=0.5.mat');
plot(ap_for_bins,'--');
hold on;

load('scale_equals_512_ratio=0.5.mat');
plot(ap_for_bins,'--');
hold on;
set(gca,'XTickLabel',{'0~32.20','32.20~41.84','41.84~53.16','53.16~66.35','66.35~83.57','83.57~107.45','107.45~140.06','140.06~194.66','194.66~297.59','297.59~'})
xlabel('width(px)');
ylabel('Ap');
legend('combine:scale = 16X32', 'combine:scale = 32X64','combine:scale = 64X128','combine:scale = 128X256','combine:scale = 256X512','anchors:scale = 16X32', 'anchors:scale = 32X64','anchors:scale = 64X128','anchors:scale = 128X256','anchors:scale = 256X512', 'Location', 'northwest');
title('Ap of bins (ratio = 0.5)');
