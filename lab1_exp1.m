function output_string=lab1_exp1(f1, harmonics)
% to be filled by students
% f1: estimated fundamental frequency in Hz
% harmonics: power of each harmonics in dB (up to 10th harmonics)

output_string='';

n=length(harmonics);    % number of elements in vector 'harmonics'
if n<10
    return              % nothing to do if n<10
end

if harmonics(1) > 10
    if harmonics(1)> 1.3* harmonics(8)
        output_string = 'Detected: /e/';
    else
        output_string = 'Detected: /a/';
    end
elseif f1 > 500
    output_string = 'Detected: /s/';
else 
    output_string = '';

end


  
