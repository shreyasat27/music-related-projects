clc 
[data,Fs]=audioread('piano_A0.wav');
tic;
% get the note windows
w = notewindows(data);

% how many notes in this sample
num_notes = length(w)-1;

for i=1:num_notes
    %take the window for the current note
    cur_note = data(w(i):w(i+1));
    len=length(cur_note);
    subplot(2,1,1)
    plot(cur_note)
    hold on
    cur_fft = abs(fft(cur_note));
    cur_fft = cur_fft(1:len/2+1);
    subplot(2,1,2)
    figure(i); 
    
    [Y,I] = max(cur_fft);
    pt=(0:len/2)*Fs/len;
    %plot(pt,cur_fft)
    I=I*Fs/len
     %I is the frequency of the note
    %z=cur_fft(1)-cur_fft(2)
    data=bandpass(data,[I-0.1,I+0.1],Fs);
    cur_n = data(w(i):w(i+1));
    len=length(cur_n);
    plot(cur_n)
    hold on
    fftn = abs(fft(cur_n));
    fftn = fftn(1:len/2+1);
    pts=(0:len/2)*Fs/len;
    plot(pts,fftn);
    for k=1:(len/2-1)
       if(abs(cur_fft(k)-cur_fft(k+1))>100)
            I=k;
            break;
        end
    end
    freq(i) = I*Fs/len;
end

%let's go through one more time to get rid of any noisy notes
j=1;
for i=1:num_notes
    if ((freq(i) > 20) && (freq(i) < 20000))
        f(j) = freq(i);
        j=j+1;
    end
end

for i=1:length(f)
    disp(f(i))
    [p,o] = findpitch(f(i));
    %notes(i,1) = 
    disp(p) 
    disp(o+4)
    notes(i,2) = o;
    notes(i,3) = p;
end
toc
%  noteparse.m

% usage: divs = noteparse(data)

% takes in a double array specified by data
% and outputs a vector of division points
% that correspond to seperate and distinct notes
% in other words, trying to find when one note stops
% and another starts.

% the returned vector will include the midpoint of the
% end of note and the beginning of the next.

function divs = noteparse(data)
len = length(data);

%let's find a threshold value so we know when a note starts/stops
threshup = .2 * max(data);  % 20% of the maximum value
threshdown = .04 * max(data);

quiet=1;  % a flag so we know if we're noisy or quiet right now
j=1;

for i=51:len-50
   if quiet == 1  % we're trying find the begining of a note
      if (max(abs(data(i-50:i+50))) > threshup)
         quiet = 0;  % we found it
         divs(j) = i;  %record this division point
         j=j+1;
      end
	else
      if (max(abs(data(i-50:i+50))) < threshdown)
         quiet = 1;  %note's over
         divs(j) = i;
         j=j+1;
      end
   end
end
end
% notewindows

% usage:
%   w = notewindows(data)
%
%  and data is the sampled sound

function w = notewindows(data)
% this is basically just a nice,pretty wrapper for noteparse

divs = noteparse(data);

% let's first massage the intervals by adding the beginning and end points

d2(1) = 0;

for i=1:length(divs)
    d2(i+1)=divs(i);
end

d2(length(divs)+2) = length(data);

for i=1:length(d2)/2
    w(i) = (d2(2*i-1) + d2(2*i))/2;
end
end
% noterecog.m

% note recognition function
% usage: notes = noterecog(data)
%
% where data is an array of sample points

%function notes = noterecog(data)

function [pitch, octave] = findpitch(freq)
%%%% Function takes in a frequency and returns the musical pitch of the frequency 
%%%% and its octave relative to the octave above middle C. 

%%%% Notes of the musical scale are assigned the following numerical values:
%%%% C  = 1
%%%% C# = 2
%%%% D  = 3
%%%% D# = 4
%%%% E  = 5
%%%% F  = 6
%%%% F# = 7
%%%% G  = 8
%%%% G# = 9
%%%% A  = 10
%%%% A# = 11
%%%% B  = 12

%%%% Octaves relative to the 12 notes of the "middle-C octave" are assigned a number 
%%%% corresponding to the number of octaves above or below the middle-C octave.  
%%%% For example a B two octaves above the B in the middle-C octave is assigned (12, 2),
%%%% while a B two octaves below the middle-C octave is assigned (12, -2).
octave = helpfindoctave(freq, 0);
pitch = choosepitch(freq/2^octave);
end

function oct = helpfindoctave(f, o)
%%%% Function checks to see if f is in the acceptable range.  If it is, then
%%%% function returns the octave count, "o".  If it is not, the function determines whether 
%%%% pitch is too high or too low, adds the appropriate number to the octave count,
%%%% "o", and recurs on itself until the frequency, "f", is in the proper range. 

if f >= 254.284 &&  f <= 508.5675
    oct = o;
elseif f < 254.284
    oct = helpfindoctave(2*f, o-1);
elseif f > 508.5675
    oct = helpfindoctave(f/2, o+1);
end
end
function p = choosepitch(f)
%%%% Function takes in a number and returns a number.  That is, it takes in a frequency,
%%%% and returns the number of the musical pitch.  Notes the the frequency must be in the 
%%%% middle-C octave range or else the function will return an error.

if f >= 254.284 && f < 269.4045
    p = 1;
    disp('C');
elseif f >= 269.4045 && f < 285.424
    p = 2;
    disp('C#');
elseif f >= 285.424 && f < 302.396
    p = 3;
    disp('D');
elseif f >= 302.396 && f < 320.3775
    p = 4;
    disp('D#');
elseif f >= 320.3775 && f < 339.428
    p = 5;
    disp('E');
elseif f >= 339.428 && f < 359.611
    p = 6;
elseif f >= 359.611 && f < 380.9945
    p = 7;
elseif f >= 380.9945 && f < 403.65
    p = 8;
elseif f >= 403.65 && f < 427.6525
    p = 9;
elseif f >= 427.6525 && f < 453.082
    p = 10;
elseif f >= 453.082 && f < 480.0235
    p = 11;
elseif f >= 480.0235 && f < 508.567
    p = 12;
else
    error('frequency outside of acceptable range')
end
end