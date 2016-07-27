%[y Fs nbits] = wavread('./samples/IMG_0811.wav');
h = actxserver('matlab.application');
y = h.GetFullMatrix('y','base',zeros(2000000),zeros(2000000));
clear y3 fcolor i y2 y2_ori y1 ev Y2 Wch W segf fev Y2height dratio sY2

y3 = abs(y);
fcolor = 0;

for i = 1:floor(length(y3)/200000)
    y2 = y3(1+(i-1)*200000:i*200000);
    y2_ori = y(1+(i-1)*200000:i*200000);
    y1 = y2(1:1000:length(y2));
    ev(i) = length(y2( y2>=mean(y1) )) / length(y2);
    Y2 = abs(fft(y2_ori));
    Y2(1:10) = 1;
    Y2(199991:200000) = 1;
    Y2height = ceil(max(Y2));
    sY2 = zeros(1, Y2height);
    for j = 1:200000
        sY2(ceil(Y2(j))) = sY2(ceil(Y2(j))) + 1;
    end
    dratio(i) = sum(sY2 <= 10) / Y2height;
    if ev(i) < 0.375
        if dratio(i) < 0.88
            Wch(i) = 'v';
            W(i) = 0;
        else
            Wch(i) = 's';
            W(i) = 1;
        end
    else
        if dratio(i) <= 0.5
            Wch(i) = 'n';
            W(i) = 2;
        else
            segf = Y2(6000:100000-1);
            if (length(segf( segf < 10 )) / length(segf)) >= 0.95
            Wch(i) = 'n';
            W(i) = 2;
            else
            Wch(i) = 's';
            W(i) = 1;
            end
        end
    end
end

Tv = sum( W==0 )*200000/44100;
Ts = sum( W==1 )*200000/44100;

y1 = y3(1:1000:length(y3));
fev = length(y3( y3>=mean(y1) )) / length(y3);
if fev >= 0.375
    fcolor = 1;
end

h.PutWorkspaceData('W', 'base', W);
h.PutWorkspaceData('Tv', 'base', Tv);
h.PutWorkspaceData('Ts', 'base', Ts);
h.PutWorkspaceData('fcolor', 'base', fcolor);
h.PutCharArray('Wch', 'base', Wch);
